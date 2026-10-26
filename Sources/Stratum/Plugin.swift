/// A destination for published events, such as the unified log.
public protocol Plugin: Sendable {
    /// Names the plugin. Adding a second plugin with the same name replaces the first.
    var name: String { get }
    /// Whether this plugin publishes the snapshot. Every snapshot by default.
    func accepts(_ snapshot: Snapshot) -> Bool
    /// Sends the snapshot to the plugin's destination.
    func publish(_ snapshot: Snapshot)
}

extension Plugin {
    public func accepts(_ snapshot: Snapshot) -> Bool { true }
}
