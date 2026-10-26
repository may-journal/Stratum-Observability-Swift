import Foundation
import OSLog
import Stratum
import StratumOSLog
import Testing

/// Requirement 0004: writing to the unified log.
extension Requirements {
    @Suite struct OSLog {
        /// The entries the unified log holds for `subsystem` since `date`, in this process.
        func entries(_ subsystem: String, since date: Date) throws -> [OSLogEntryLog] {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let found = try store.getEntries(
                at: store.position(date: date),
                matching: NSPredicate(format: "subsystem == %@", subsystem))
            return found.compactMap { $0 as? OSLogEntryLog }
        }

        /// A person saves a note, which publishes through an OSLog plugin of its own
        /// subsystem; the log entries for that subsystem after.
        func save(_ key: String, fields: [String: String] = [:]) async throws -> [OSLogEntryLog] {
            let subsystem = "com.example.notes.\(UUID().uuidString)"
            let stratum = try notesStratum([OSLogPlugin(subsystem: subsystem)])
            let start = Date().addingTimeInterval(-1)
            try await tap("Save") { stratum.publish(key, fields: fields) }
            return try entries(subsystem, since: start)
        }

        @Test func test0004_1() async throws {
            let logged = try await save("note.saved")
            #expect(logged.map(\.category) == ["editor"])
            #expect(logged.first?.composedMessage.hasPrefix("note.saved") == true)
        }

        @Test func test0004_2() async throws {
            let logged = try await save("sync.failed")
            #expect(logged.map(\.level) == [.error])
        }

        @Test func test0004_3() async throws {
            let logged = try await save("note.saved", fields: ["words": "120"])
            #expect(logged.first?.composedMessage.contains("words=120") == true)
        }

        @Test func test0004_4() async throws {
            let logged = try await save("note.saved", fields: ["title": "Dentist at noon"])
            #expect(logged.count == 1)
            #expect(logged.first?.composedMessage.contains("Dentist") == false)
        }
    }
}
