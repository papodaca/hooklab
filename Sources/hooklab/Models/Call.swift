import Fluent
import Vapor

final class Call: Model, Content, @unchecked Sendable {
  static let schema = "calls"

  @ID(key: .id) var id: UUID?
  @Field(key: "method") var method: String
  @Field(key: "headers") var headers: [String: String]
  @Field(key: "body") var body: String
  @Parent(key: "project_id") var project: Project

  init() {}

  init(id: UUID? = nil, method: String, headers: [String: String], body: String, project: Project) {
    self.id = id
    self.method = method
    self.headers = headers
    self.body = body
    self.project = project
  }
}
