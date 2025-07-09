import Fluent
import Vapor

struct CallsController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    let calls = routes.grouped("calls")
    calls.get(use: index)

    calls.group(":id") { call in
      call.get(use: show)
      call.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [Call] {
    try await Call.query(on: req.db).all()
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
}
