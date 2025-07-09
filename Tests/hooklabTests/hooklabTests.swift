@testable import hooklab
import VaporTesting
import Testing
import Fluent

@Suite("Project Tests", .serialized)
struct ProjectsControllerTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Getting all projects")
    func testGetAllProjects() async throws {
        try await withApp { app in
            let sampleProjects = [Project(name: "sample1"), Project(name: "sample2")]
            try await sampleProjects.create(on: app.db)
            
            try await app.testing().test(.GET, "projects", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let projects = try res.content.decode([Project].self)
                #expect(projects.count == 2)
                #expect(projects[0].name == "sample1")
                #expect(projects[1].name == "sample2")
            })
        }
    }

    @Test("Creating a project")
    func testCreateProject() async throws {
        let newProject = Project(name: "newProject")
        
        try await withApp { app in
            try await app.testing().test(.POST, "projects", beforeRequest: { req in
                try req.content.encode(newProject)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let projects = try await Project.query(on: app.db).all()
                #expect(projects.count == 1)
                #expect(projects[0].name == "newProject")
            })
        }
    }

    @Test("Getting a single project")
    func testGetProject() async throws {
        try await withApp { app in
            let project = Project(name: "testProject")
            try await project.create(on: app.db)
            
            try await app.testing().test(.GET, "projects/\(project.requireID())", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let fetchedProject = try res.content.decode(Project.self)
                #expect(fetchedProject.name == "testProject")
            })
        }
    }

    @Test("Updating a project")
    func testUpdateProject() async throws {
        try await withApp { app in
            let project = Project(name: "oldName")
            try await project.create(on: app.db)
            
            let updatedProject = Project(name: "newName")
            
            try await app.testing().test(.PUT, "projects/\(project.requireID())", beforeRequest: { req in
                try req.content.encode(updatedProject)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let fetchedProject = try await Project.find(project.id, on: app.db)
                #expect(fetchedProject?.name == "newName")
            })
        }
    }

    @Test("Deleting a project")
    func testDeleteProject() async throws {
        try await withApp { app in
            let project = Project(name: "toBeDeleted")
            try await project.create(on: app.db)
            
            try await app.testing().test(.DELETE, "projects/\(project.requireID())", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let project = try await Project.find(project.id, on: app.db)
                #expect(project == nil)
            })
        }
    }
}

@Suite("Hook Tests", .serialized)
struct HookControllerTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Handling a hook")
    func testHandleHook() async throws {
        try await withApp { app in
            let project = Project(name: "hookProject")
            try await project.create(on: app.db)
            
            try await app.testing().test(.POST, "hook/\(project.requireID())", beforeRequest: { req in
                req.headers.add(name: "X-Test-Header", value: "test-value")
                try req.content.encode(["key": "value"])
            } ,afterResponse: { res async throws in
                #expect(res.status == .ok)
                let calls = try await Call.query(on: app.db).all()
                #expect(calls.count == 1)
                #expect(calls[0].method == "POST")
                #expect(calls[0].headers["X-Test-Header"] == "test-value")
                #expect(calls[0].body.contains("key"))
                #expect(calls[0].body.contains("value"))
            })
        }
    }
}

extension Project: Equatable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
