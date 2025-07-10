import Vapor

#if os(macOS)
    import Compression
#elseif os(Linux)
    import Gzip
#endif

#if !DEBUG
    struct EmbeddedFileMiddleware: AsyncMiddleware {
        func respond(to request: Request, chainingTo next: any AsyncResponder) async throws
            -> Response
        {
            // If the request is for an API route, pass it to the next responder.
            if request.url.path.starts(with: "/api/") {
                return try await next.respond(to: request)
            }

            let path = request.url.path.isEmpty ? "/" : request.url.path

            // Check if the requested file exists in our embedded assets.
            if let fileBytes = EmbeddedAssets.files[path] {
                return self.response(
                    for: fileBytes, with: request, fileExtension: (path as NSString).pathExtension)
            }

            // If the file is not found, check for index.html for SPA routing.
            if let indexBytes = EmbeddedAssets.files["/index.html"] {
                return self.response(for: indexBytes, with: request, fileExtension: "html")
            }

            // If neither the file nor index.html is found, return a 404.
            return Response(status: .notFound, body: .init(string: "Not Found"))
        }

        private func response(for bytes: [UInt8], with request: Request, fileExtension: String)
            -> Response
        {
            do {
                let outputData: Data
                #if os(macOS)
                    outputData = try (Data(bytes) as NSData).decompressed(using: .zlib)
                #elseif os(Linux)
                    outputData = try Data(bytes).gunzipped()
                #else
                    outputData = Data(bytes)
                #endif
                var headers = HTTPHeaders()
                headers.contentType = HTTPMediaType.fileExtension(fileExtension) ?? .plainText
                var buffer = request.application.allocator.buffer(capacity: outputData.count)
                buffer.writeBytes(outputData)
                return Response(status: .ok, headers: headers, body: .init(buffer: buffer))
            } catch {
                return Response(
                    status: .internalServerError, body: .init(string: "Failed to decompress file"))
            }
        }
    }
#endif
