import Fluent
import Vapor

final class Call: Model, Content, @unchecked Sendable {
  static let schema = "calls"

  @ID(key: .id) var id: UUID?
  @Field(key: "method") var method: String
  @Field(key: "time") var time: Date
  @Field(key: "source") var source: String
  @Field(key: "path") var path: String
  @Field(key: "params") var params: String
  @Field(key: "headers") var headers: [String: String]
  @Field(key: "body") var body: String
  @Parent(key: "project_id") var project: Project

  init() {}

  init(
    id: UUID? = nil, method: String, path: String, params: String, source: String,
    headers: [String: String], body: String,
    project: Project
  ) throws {
    self.id = id
    self.method = method
    self.time = Date.now
    self.path = path
    self.params = params
    self.source = source
    self.headers = headers
    self.body = body
    self.$project.id = try project.requireID()
  }
}
