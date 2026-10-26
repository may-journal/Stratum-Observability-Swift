import Foundation
import Stratum
import SwiftUI
import Synchronization
import Testing
import UITestingLibrary

/// The one serialized parent every requirement suite nests under, since the screen a person
/// taps is one window at a time.
@Suite(.serialized)
@MainActor
struct Requirements {}

/// A screen with one button, whose tap runs what the app does in response, as an app's own
/// button publishes an event when a person uses it.
struct ButtonScreen: View {
    let title: String
    let action: @MainActor () -> Void

    var body: some View {
        Button(title, action: action)
    }
}

/// A person taps a button whose action is `action`, on a screen of its own.
@MainActor
func tap(_ title: String, _ action: @escaping @MainActor () -> Void) async throws {
    let screen = try Screen.render { ButtonScreen(title: title, action: action) }
    try await User(screen).taps(.button(title))
    try screen.close()
}

/// A plugin an app writes for itself, which keeps every snapshot it receives.
final class Recorder: Plugin {
    let name: String
    let only: Level?
    private let received = Mutex<[Snapshot]>([])

    init(name: String = "recorder", only: Level? = nil) {
        self.name = name
        self.only = only
    }

    var snapshots: [Snapshot] { received.withLock { $0 } }

    func accepts(_ snapshot: Snapshot) -> Bool {
        only.map { $0 == snapshot.event.level } ?? true
    }

    func publish(_ snapshot: Snapshot) {
        received.withLock { $0.append(snapshot) }
    }
}

/// The catalog most requirements start from: a note a person saves, and a failed sync.
let notes = Catalog(
    name: "Notes", version: "1.0",
    events: [
        "note.saved": Event(
            "A person saved a note", category: "editor",
            publicFields: ["words"], privateFields: ["title"]),
        "sync.failed": Event("The notes failed to sync", category: "sync", level: .error),
    ])

/// A service for the notes product with `plugins`.
func notesStratum(_ plugins: [any Plugin] = []) throws -> Stratum {
    try Stratum(product: "Notes", version: "2.1", catalogs: [notes], plugins: plugins)
}
