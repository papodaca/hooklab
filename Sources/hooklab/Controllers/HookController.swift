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
    let call = Call(
      method: req.method.rawValue,
      headers: headers,
      body: req.body.string ?? "",
      project: project
    )
    try await call.create(on: req.db)
    return .ok
  }
}
