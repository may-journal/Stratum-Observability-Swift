import Foundation

/// One published event, frozen at the moment the app published it. Plugins and listeners
/// receive the same snapshot, so a later change to the context never reaches it.
public struct Snapshot: Sendable, Equatable {
    /// The key the app published.
    public let key: String
    public let event: Event
    public let catalog: String
    public let catalogVersion: String
    public let product: String
    public let productVersion: String
    /// The same for every event of one app launch.
    public let session: UUID
    public let date: Date
    /// The context the app had set when it published.
    public let context: [String: String]
    /// The fields the event names as public, with the values the app passed.
    public let publicFields: [String: String]
    /// The fields the event names as private, with the values the app passed.
    public let privateFields: [String: String]
}
