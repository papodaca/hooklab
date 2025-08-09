import Fluent
import FluentSQLiteDriver
import Path
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    var databaseCreated = false

    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
        databaseCreated = true
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
            databaseCreated = true
        } else {
            app.logger.info("database file seems to exist, mobing on \(dbPath)")
        }

        app.databases.use(.sqlite(.file(dbPath.string)), as: .sqlite)
    }
    if databaseCreated {
        app.migrations.add(CreateTables())
        try await app.autoMigrate()
    }

    // register routes
    try routes(app)
}
