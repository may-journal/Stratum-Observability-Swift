import Foundation
import Synchronization

/// The service an app publishes catalogued events through. It holds the catalogs, the
/// plugins and the context, and turns each published key into one snapshot for every plugin
/// that accepts it. Every method is safe to call from any thread.
public final class Stratum: Sendable {
    /// The session every Stratum in this launch stamps on its snapshots.
    public static let launch = UUID()

    public let product: String
    public let productVersion: String
    private let state = Mutex(State())

    private struct State {
        var catalogs: [String: Catalog] = [:]
        var plugins: [any Plugin] = []
        var context: [String: String] = [:]
        var listeners: [@Sendable (Snapshot) -> Void] = []
    }

    /// Starts a service for one product, with its first catalogs and plugins.
    public init(
        product: String, version: String, catalogs: [Catalog] = [], plugins: [any Plugin] = []
    ) throws {
        self.product = product
        self.productVersion = version
        for catalog in catalogs { try add(catalog) }
        for plugin in plugins { add(plugin) }
    }

    /// Adds a catalog, or replaces the one with the same name. Throws when an event cannot be
    /// published or another catalog already holds one of its keys.
    public func add(_ catalog: Catalog) throws {
        for (key, event) in catalog.events.sorted(by: { $0.key < $1.key }) {
            if let reason = event.problem(key: key) {
                throw CatalogError.invalidEvent(key: key, reason: reason)
            }
        }
        try state.withLock { state in
            for other in state.catalogs.values where other.name != catalog.name {
                if let key = catalog.events.keys.sorted().first(where: { other.events[$0] != nil })
                {
                    throw CatalogError.duplicateKey(key: key, catalog: other.name)
                }
            }
            state.catalogs[catalog.name] = catalog
        }
    }

    /// Removes a catalog, so its events no longer publish.
    public func removeCatalog(named name: String) {
        state.withLock { _ = $0.catalogs.removeValue(forKey: name) }
    }

    /// Adds a plugin, or replaces the one with the same name.
    public func add(_ plugin: any Plugin) {
        state.withLock { state in
            state.plugins.removeAll { $0.name == plugin.name }
            state.plugins.append(plugin)
        }
    }

    /// Sets a context value every later snapshot carries, or clears it with nil. Context is
    /// public: keep what a person wrote out of it.
    public func setContext(_ value: String?, for key: String) {
        state.withLock { $0.context[key] = value }
    }

    /// Calls `listener` with every snapshot this service publishes.
    public func addListener(_ listener: @escaping @Sendable (Snapshot) -> Void) {
        state.withLock { $0.listeners.append(listener) }
    }

    /// Publishes the event a catalog holds under `key`, with the fields it names. Returns
    /// whether a catalog held the key; nothing is delivered when none does.
    @discardableResult
    public func publish(_ key: String, fields: [String: String] = [:]) -> Bool {
        let found = state.withLock { state in
            state.catalogs.values.first { $0.events[key] != nil }
                .map { ($0, state.context, state.plugins, state.listeners) }
        }
        guard let (catalog, context, plugins, listeners) = found,
            let event = catalog.events[key]
        else { return false }
        let snapshot = Snapshot(
            key: key, event: event, catalog: catalog.name, catalogVersion: catalog.version,
            product: product, productVersion: productVersion, session: Self.launch,
            date: Date(), context: context,
            publicFields: fields.filter { event.publicFields.contains($0.key) },
            privateFields: fields.filter { event.privateFields.contains($0.key) })
        for listener in listeners { listener(snapshot) }
        for plugin in plugins where plugin.accepts(snapshot) { plugin.publish(snapshot) }
        return true
    }
}
