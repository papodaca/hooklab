import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        //TODO redirect to /projects
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    try app.register(collection: ProjectsController())
    try app.register(collection: HookController())

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}
