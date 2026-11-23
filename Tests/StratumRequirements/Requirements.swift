import Foundation
import Stratum
import StratumTesting
import SwiftUI
import Testing
import UITestingLibrary

/// The one serialized parent every requirement suite nests under, since the screen a person
/// taps is one window at a time.
@Suite(.serialized)
@MainActor
struct Requirements {}

/// A screen with one button whose tap runs the app's response.
/// An app's own button publishes an event when a person uses it.
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

/// The shipped recorder, under the short name every requirement suite uses.
typealias Recorder = StratumTesting.Recorder

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
