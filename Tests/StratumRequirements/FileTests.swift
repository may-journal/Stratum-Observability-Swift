import Foundation
import Stratum
import StratumFile
import Testing

/// Requirement 0007: sharing a diagnostics file of events.
extension Requirements {
    @Suite struct Files {
        /// A file plugin that writes to a fresh temporary folder.
        func plugin(maxBytes: Int = 1_000_000) throws -> FilePlugin {
            let folder = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
            return try FilePlugin(url: folder.appending(path: "events.jsonl"), maxBytes: maxBytes)
        }

        /// The JSON objects the file at `url` holds, one for each line.
        func lines(_ url: URL) throws -> [[String: Any]] {
            let text = try String(contentsOf: url, encoding: .utf8)
            return try text.split(separator: "\n").map { line in
                let object = try JSONSerialization.jsonObject(with: Data(line.utf8))
                return try #require(object as? [String: Any])
            }
        }

        @Test func test0007_1() async throws {
            let file = try plugin()
            let stratum = try notesStratum([file])
            try await tap("Save") { stratum.publish("note.saved", fields: ["words": "120"]) }
            let written = try lines(file.url)
            #expect(written.count == 1)
            #expect(written.first?["key"] as? String == "note.saved")
            #expect(written.first?["fields"] as? [String: String] == ["words": "120"])
        }

        @Test func test0007_2() async throws {
            let file = try plugin()
            let stratum = try notesStratum([file])
            try await tap("Save") {
                stratum.publish("note.saved", fields: ["title": "Dentist at noon"])
            }
            let text = try String(contentsOf: file.url, encoding: .utf8)
            #expect(try lines(file.url).first?["private"] as? [String] == ["title"])
            #expect(!text.contains("Dentist"))
        }

        @Test func test0007_3() async throws {
            let file = try plugin(maxBytes: 300)
            let stratum = try notesStratum([file])
            try await tap("Save") {
                stratum.publish("note.saved")
                stratum.publish("sync.failed")
            }
            #expect(try lines(file.olderURL).map { $0["key"] as? String } == ["note.saved"])
            #expect(try lines(file.url).map { $0["key"] as? String } == ["sync.failed"])
        }
    }
}
