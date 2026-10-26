/// How serious an event is. Each plugin maps it onto its own scale.
public enum Level: String, Sendable, CaseIterable {
    case debug, info, notice, error, fault
}
