import Stratum
import Synchronization

/// A plugin for an app's own tests, which keeps every snapshot it receives in publishing order.
public final class Recorder: Plugin {
    public let name: String
    /// The one level this recorder accepts, or nil when it accepts every level.
    public let only: Level?
    private let received = Mutex<[Snapshot]>([])

    public init(name: String = "recorder", only: Level? = nil) {
        self.name = name
        self.only = only
    }

    /// Every snapshot received since the last reset, oldest first.
    public var snapshots: [Snapshot] { received.withLock { $0 } }

    /// The key of every snapshot received, oldest first.
    public var keys: [String] { snapshots.map(\.key) }

    /// The newest snapshot, or nil when none has arrived.
    public var last: Snapshot? { snapshots.last }

    /// The snapshots published under `key`, oldest first.
    public func snapshots(for key: String) -> [Snapshot] {
        snapshots.filter { $0.key == key }
    }

    /// Forgets every snapshot, so one recorder can serve the next test.
    public func reset() {
        received.withLock { $0.removeAll() }
    }

    public func accepts(_ snapshot: Snapshot) -> Bool {
        only.map { $0 == snapshot.event.level } ?? true
    }

    public func publish(_ snapshot: Snapshot) {
        received.withLock { $0.append(snapshot) }
    }
}
