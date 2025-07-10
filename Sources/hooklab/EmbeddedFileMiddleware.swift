import Vapor

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
            var headers = HTTPHeaders()
            headers.contentType = HTTPMediaType.fileExtension(fileExtension) ?? .plainText
            var buffer = request.application.allocator.buffer(capacity: bytes.count)
            buffer.writeBytes(bytes)
            return Response(status: .ok, headers: headers, body: .init(buffer: buffer))
        }
    }
#endif
