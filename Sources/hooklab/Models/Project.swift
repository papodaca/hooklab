import Fluent
import Vapor

final class Project: Model, Content, @unchecked Sendable {
  static let schema = "projects"

  @ID(key: .id) var id: UUID?
  @Field(key: "name") var name: String
  @Field(key: "color") var color: String

  init() {}

  init(id: UUID? = nil, name: String, color: String) {
    self.id = id
    self.name = name
    self.color = color
  }
}
