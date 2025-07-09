import Fluent
import Vapor

struct CallsController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    let calls = routes.grouped("calls")
    calls.get(use: index)
    calls.webSocket("ws", onUpgrade: self.webSocket)

    calls.group(":id") { call in
      call.get(use: show)
      call.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [Call] {
    let query = Call.query(on: req.db)

    if let projectIdString = try? req.query.get(String.self, at: "projectId"),
      let projectId = UUID(uuidString: projectIdString)
    {
      query.filter(\.$project.$id == projectId)
    }

    return try await query.sort(\.$time, .descending).all()
  }

  func show(req: Request) async throws -> Call {
    guard let call = try await Call.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    return call
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let call = try await Call.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await call.delete(on: req.db)
    return .ok
  }

  func webSocket(req: Request, ws: WebSocket) async {
    await WebSocketManager.shared.add(connection: ws)
  }
}
