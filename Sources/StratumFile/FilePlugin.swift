import Foundation
import Stratum
import Synchronization

/// Appends each snapshot to a file on the device as one JSON line, so the app can share it.
/// Private fields appear by name only, and the file rolls to one older file at its size cap.
public final class FilePlugin: Plugin {
    public let name = "file"
    /// The file new lines go to.
    public let url: URL
    /// The size at which the file rolls over, in bytes.
    public let maxBytes: Int
    private let writing = Mutex<Void>(())

    /// Creates the file's folder when it is missing.
    public init(url: URL, maxBytes: Int = 1_000_000) throws {
        self.url = url
        self.maxBytes = maxBytes
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    }

    /// The one older file, which holds the lines written before the last rollover.
    public var olderURL: URL {
        let kind = url.pathExtension
        return url.deletingPathExtension().appendingPathExtension("1").appendingPathExtension(kind)
    }

    public func publish(_ snapshot: Snapshot) {
        guard let line = try? Self.line(snapshot) else { return }
        writing.withLock { _ in
            // A failed write drops the line, since logging must never crash the app.
            try? append(line)
        }
    }

    /// The snapshot as one JSON object with sorted keys, ending in a newline.
    static func line(_ snapshot: Snapshot) throws -> Data {
        let object: [String: Any] = [
            "date": snapshot.date.formatted(.iso8601),
            "key": snapshot.key,
            "category": snapshot.event.category,
            "level": snapshot.event.level.rawValue,
            "session": snapshot.session.uuidString,
            "context": snapshot.context,
            "fields": snapshot.publicFields,
            "private": snapshot.privateFields.keys.sorted(),
        ]
        let json = try JSONSerialization.data(
            withJSONObject: object, options: [.sortedKeys, .withoutEscapingSlashes])
        return json + Data("\n".utf8)
    }

    private func append(_ line: Data) throws {
        let files = FileManager.default
        let size = (try? files.attributesOfItem(atPath: url.path)[.size] as? Int) ?? 0
        if size > 0, size + line.count > maxBytes {
            try? files.removeItem(at: olderURL)
            try files.moveItem(at: url, to: olderURL)
        }
        if !files.fileExists(atPath: url.path) {
            try line.write(to: url)
            return
        }
        let handle = try FileHandle(forWritingTo: url)
        defer { try? handle.close() }
        try handle.seekToEnd()
        try handle.write(contentsOf: line)
    }
}
