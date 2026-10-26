/// A named, versioned set of events, keyed by the name the app publishes each one under.
public struct Catalog: Sendable {
    public let name: String
    public let version: String
    public let events: [String: Event]

    public init(name: String, version: String, events: [String: Event]) {
        self.name = name
        self.version = version
        self.events = events
    }
}
