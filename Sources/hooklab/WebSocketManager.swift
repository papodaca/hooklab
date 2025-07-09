import Vapor
import Foundation

actor WebSocketManager {
    private var connections: [UUID: WebSocket] = [:]

    static let shared = WebSocketManager()

    private init() {}

    func add(connection: WebSocket) {
        let id = UUID()
        connections[id] = connection
        connection.onClose.whenComplete { [weak self] _ in
            Task {
                await self?.remove(id: id)
            }
        }
    }

    func broadcast(message: String) {
        for conn in connections.values {
            conn.send(message)
        }
    }

    private func remove(id: UUID) {
        connections.removeValue(forKey: id)
    }
}