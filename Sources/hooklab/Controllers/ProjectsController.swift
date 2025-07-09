import Fluent
import Vapor

struct ProjectsController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    let projects = routes.grouped("projects")
    projects.get(use: index)
    projects.post(use: create)

    projects.group(":id") { project in
      project.get(use: show)
      project.put(use: update)
      project.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [Project] {
    try await Project.query(on: req.db).all()
  }

  func create(req: Request) async throws -> Project {
    let project = try req.content.decode(Project.self)
    try await project.save(on: req.db)
    return project
  }

  func show(req: Request) async throws -> Project {
    guard let project = try await Project.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    return project
  }

  func update(req: Request) async throws -> Project {
    guard let project = try await Project.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    let updatedProject = try req.content.decode(Project.self)
    project.name = updatedProject.name
    try await project.save(on: req.db)
    return project
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let project = try await Project.find(req.parameters.get("id"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await project.delete(on: req.db)
    return .ok
  }
}
