import Stratum
import Synchronization
import Testing

/// Requirement 0002: what each published event carries.
extension Requirements {
    @Suite struct Snapshots {
        @Test func test0002_1() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            stratum.setContext("Today", for: "screen")
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(recorder.snapshots.first?.context == ["screen": "Today"])
        }

        @Test func test0002_2() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") {
                stratum.publish("note.saved", fields: ["words": "120", "body": "Call the dentist"])
            }
            let snapshot = try #require(recorder.snapshots.first)
            #expect(snapshot.publicFields == ["words": "120"])
            #expect(snapshot.privateFields.isEmpty)
        }

        @Test func test0002_3() async throws {
            let editor = Recorder()
            let widget = Recorder()
            let app = try notesStratum([editor])
            let extensionStratum = try notesStratum([widget])
            try await tap("Save") {
                app.publish("note.saved")
                extensionStratum.publish("note.saved")
            }
            let sessions = (editor.snapshots + widget.snapshots).map(\.session)
            #expect(sessions.count == 2)
            #expect(Set(sessions).count == 1)
        }

        @Test func test0002_4() async throws {
            let stratum = try notesStratum()
            let heard = Mutex<[String]>([])
            stratum.addListener { snapshot in heard.withLock { $0.append(snapshot.key) } }
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(heard.withLock { $0 } == ["note.saved"])
        }
    }
}
