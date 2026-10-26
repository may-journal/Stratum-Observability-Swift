/// One event a catalog describes: what it means, where it belongs, and which fields it may
/// carry. A field the event does not name is dropped when the event is published.
public struct Event: Sendable, Hashable {
    /// What happened, in words a teammate reading the log understands.
    public var meaning: String
    /// The area of the app the event belongs to, such as a `Logger` category.
    public var category: String
    public var level: Level
    /// Fields whose values may be shown anywhere, such as a count or a duration.
    public var publicFields: Set<String>
    /// Fields whose values a plugin must keep private, such as anything a person wrote.
    public var privateFields: Set<String>

    public init(
        _ meaning: String, category: String, level: Level = .info,
        publicFields: Set<String> = [], privateFields: Set<String> = []
    ) {
        self.meaning = meaning
        self.category = category
        self.level = level
        self.publicFields = publicFields
        self.privateFields = privateFields
    }

    /// Why the event cannot be published, or nil when it can.
    func problem(key: String) -> String? {
        if key.isEmpty || key.contains(where: \.isWhitespace) {
            return "its key must be one word"
        }
        if category.isEmpty || category.contains(where: \.isWhitespace) {
            return "its category must be one word"
        }
        if let field = publicFields.intersection(privateFields).sorted().first {
            return "field \(field) is both public and private"
        }
        return nil
    }
}
