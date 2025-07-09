import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        req.redirect(to: "index.html", redirectType: .permanent)
    }

    try app.register(collection: ProjectsController())
    try app.register(collection: HookController())

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}
