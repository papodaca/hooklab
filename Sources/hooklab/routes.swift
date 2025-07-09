import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        req.redirect(to: "index.html", redirectType: .permanent)
    }

    let api = app.grouped("api")

    try api.register(collection: ProjectsController())
    try api.register(collection: HookController())

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}
