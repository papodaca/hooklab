import Fluent
import Vapor

struct HookController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    routes.grouped("hook").group(":id") { h in
      h.post(use: handle)
      h.put(use: handle)
      h.delete(use: handle)
      h.patch(use: handle)
      h.get(use: handle)
    }
  }

  func handle(req: Request) async throws -> HTTPStatus {
    guard let project = try await Project.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    var headers: [String: String] = [:]
    for (key, value) in req.headers {
      headers[key] = value
    }
    let call = try Call(
      method: req.method.rawValue,
      path: req.url.path,
      params: req.url.query ?? "",
      source: req.peerAddress?.ipAddress ?? "unknown",
      headers: headers,
      body: req.body.string ?? "",
      project: project
    )
    try await call.create(on: req.db)

    // Broadcast the new call to all connected WebSocket clients
    Task {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(call)
            await WebSocketManager.shared.broadcast(message: String(data: data, encoding: .utf8) ?? "")
        } catch {
            req.logger.error("Failed to broadcast call: \(error)")
        }
    }

    return .ok
  }
}
