import Stratum
import StratumTesting
import Testing

/// Requirement 0006: asserting what an app published.
extension Requirements {
    @Suite struct Recording {
        @Test func test0006_1() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") {
                stratum.publish("note.saved")
                stratum.publish("sync.failed")
            }
            #expect(recorder.keys == ["note.saved", "sync.failed"])
        }

        @Test func test0006_2() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") {
                stratum.publish("note.saved", fields: ["words": "120"])
                stratum.publish("sync.failed")
            }
            let saved = recorder.snapshots(for: "note.saved")
            #expect(saved.map(\.publicFields) == [["words": "120"]])
        }

        @Test func test0006_3() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") { stratum.publish("note.saved") }
            recorder.reset()
            try await tap("Sync") { stratum.publish("sync.failed") }
            #expect(recorder.keys == ["sync.failed"])
            #expect(recorder.last?.event.level == .error)
        }
    }
}
