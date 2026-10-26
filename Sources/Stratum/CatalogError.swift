/// Why Stratum refused a catalog.
public enum CatalogError: Error, Equatable, CustomStringConvertible {
    /// An event in the catalog cannot be published.
    case invalidEvent(key: String, reason: String)
    /// Another catalog already holds an event under this key.
    case duplicateKey(key: String, catalog: String)

    public var description: String {
        switch self {
        case .invalidEvent(let key, let reason): "event \(key) is invalid: \(reason)"
        case .duplicateKey(let key, let catalog): "event \(key) is already in catalog \(catalog)"
        }
    }
}
