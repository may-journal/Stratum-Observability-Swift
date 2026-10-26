import Stratum
import Testing

/// Requirement 0001: publishing what a catalog names.
extension Requirements {
    @Suite struct Catalogs {
        @Test func test0001_1() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(recorder.snapshots.map(\.key) == ["note.saved"])
        }

        @Test func test0001_2() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            try await tap("Save") { stratum.publish("note.shared") }
            #expect(recorder.snapshots.isEmpty)
        }

        @Test func test0001_3() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            let sharing = Catalog(
                name: "Sharing", version: "1.0",
                events: ["note.shared": Event("A person shared a note", category: "share")])
            try stratum.add(sharing)
            try await tap("Share") { stratum.publish("note.shared") }
            #expect(recorder.snapshots.map(\.catalog) == ["Sharing"])
        }

        @Test func test0001_4() async throws {
            let recorder = Recorder()
            let stratum = try notesStratum([recorder])
            stratum.removeCatalog(named: "Notes")
            try await tap("Save") { stratum.publish("note.saved") }
            #expect(recorder.snapshots.isEmpty)
        }

        @Test func test0001_5() throws {
            let stratum = try notesStratum()
            let spaced = Catalog(
                name: "Sharing", version: "1.0",
                events: ["note shared": Event("A person shared a note", category: "share")])
            #expect(
                throws: CatalogError.invalidEvent(
                    key: "note shared", reason: "its key must be one word")
            ) {
                try stratum.add(spaced)
            }
        }

        @Test func test0001_6() throws {
            let stratum = try notesStratum()
            let clash = Catalog(
                name: "Drafts", version: "1.0",
                events: ["note.saved": Event("A person saved a draft", category: "drafts")])
            #expect(throws: CatalogError.duplicateKey(key: "note.saved", catalog: "Notes")) {
                try stratum.add(clash)
            }
        }
    }
}
