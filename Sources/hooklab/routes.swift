import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        req.redirect(to: "index.html", redirectType: .permanent)
    }

    let api = app.grouped("api")

    try api.register(collection: ProjectsController())
    try api.register(collection: HookController())
    try api.register(collection: CallsController())

    #if !DEBUG
        app.middleware.use(EmbeddedFileMiddleware())
    #else
        app.middleware.use(
            FileMiddleware(
                publicDirectory: app.directory.workingDirectory + "Public/",
                defaultFile: "index.html"))
    #endif
}
