import Fluent
import FluentSQLiteDriver
import Path
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    if app.environment.isRelease {
        app.middleware.use(EmbeddedFileMiddleware())
    } else {
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.workingDirectory + "Public/", defaultFile: "index.html"))
    }

    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        let prefPath = prefrencesPath(app)
        let prefDir = Path.root.join(prefPath.path()).join("hooklab")
        let dbPath = prefDir.join("db.sqlite")

        app.logger.info("Found prefs location \(prefDir)")

        app.logger.info("checking if \(prefDir) exists")
        if !prefDir.isDirectory {
            app.logger.info("creating \(prefDir)")
            try prefDir.mkdir()
        } else {
            app.logger.info("\(prefDir) exists")
        }

        app.logger.info("checking if \(dbPath) exists")
        if !dbPath.isFile {
            app.logger.info("creating new database \(dbPath)")
            try dbPath.touch()
        } else {
            app.logger.info("database file seems to exist, mobing on \(dbPath)")
        }

        app.databases.use(.sqlite(.file(dbPath.string)), as: .sqlite)
    }
    app.migrations.add(CreateTables())
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
