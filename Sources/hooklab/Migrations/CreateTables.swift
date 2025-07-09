import Fluent
import Vapor

struct CreateTables: AsyncMigration {
  func prepare(on database: any Database) async throws {
    try await database.schema("projects")
      .id()
      .field("name", .string, .required)
      .field("color", .string, .required)
      .create()
    try await database.schema("calls")
      .id()
      .field("method", .string, .required)
      .field("time", .datetime, .required)
      .field("path", .string, .required)
      .field("params", .string, .required)
      .field("source", .string, .required)
      .field("headers", .json, .required)
      .field("body", .string, .required)
      .field("project_id", .uuid, .required, .references("projects", "id"))
      .create()
  }

  func revert(on database: any Database) async throws {
    try await database.schema("calls").delete()
    try await database.schema("projects").delete()
  }
}
