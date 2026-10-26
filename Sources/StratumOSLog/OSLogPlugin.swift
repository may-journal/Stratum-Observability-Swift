import Stratum
import os

/// Writes each snapshot to Apple's unified log, under the app's subsystem and the event's
/// category, at the event's level. Its key and public fields read in the clear; its private
/// fields are redacted unless the device allows private data.
public struct OSLogPlugin: Plugin {
    public let name = "oslog"
    /// The subsystem the app's own `Logger`s use, such as its bundle identifier.
    public let subsystem: String

    public init(subsystem: String) {
        self.subsystem = subsystem
    }

    public func publish(_ snapshot: Snapshot) {
        let logger = Logger(subsystem: subsystem, category: snapshot.event.category)
        let level = Self.type(of: snapshot.event.level)
        let fields = Self.line(snapshot.context.merging(snapshot.publicFields) { $1 })
        let open = fields.isEmpty ? snapshot.key : "\(snapshot.key) \(fields)"
        if snapshot.privateFields.isEmpty {
            logger.log(level: level, "\(open, privacy: .public)")
            return
        }
        let closed = Self.line(snapshot.privateFields)
        logger.log(level: level, "\(open, privacy: .public) \(closed, privacy: .private)")
    }

    /// The fields as `name=value` pairs in name order, so a reader can search the log for one.
    static func line(_ fields: [String: String]) -> String {
        fields.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)" }.joined(separator: " ")
    }

    /// The unified log's level for an event level.
    static func type(of level: Level) -> OSLogType {
        switch level {
        case .debug: .debug
        case .info: .info
        case .notice: .default
        case .error: .error
        case .fault: .fault
        }
    }
}
