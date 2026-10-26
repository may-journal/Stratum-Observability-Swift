import Stratum
import Testing

/// Requirement 0003: choosing where events go.
extension Requirements {
    @Suite struct Plugins {
        @Test func test0003_1() async throws {
            let stratum = try notesStratum()
            let recorder = Recorder()
            stratum.add(recorder)
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(recorder.snapshots.map(\.key) == ["note.saved"])
        }

        @Test func test0003_2() async throws {
            let errors = Recorder(only: .error)
            let stratum = try notesStratum([errors])
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(errors.snapshots.isEmpty)
        }

        @Test func test0003_3() async throws {
            let first = Recorder(name: "crashes")
            let second = Recorder(name: "crashes")
            let stratum = try notesStratum([first])
            stratum.add(second)
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(first.snapshots.isEmpty)
            #expect(second.snapshots.count == 1)
        }
    }
}
