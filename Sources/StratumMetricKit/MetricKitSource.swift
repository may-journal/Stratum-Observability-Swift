import Foundation
import MetricKit
import Stratum

/// Publishes MetricKit's reports as Stratum events, so every plugin sees launch, memory, crash
/// and hang numbers that arrive at most once a day.
///
/// Only `start()` touches MetricKit's subscriber API, and the rest reads a report's JSON.
public final class MetricKitSource: NSObject, Sendable {
    /// The events this source publishes. Adding the source adds this catalog.
    public static let catalog = Catalog(
        name: "MetricKit", version: "1",
        events: [
            Keys.metrics: Event(
                "The system's daily metric report", category: "metrics",
                publicFields: ["appVersion", "begin", "end", "peakMemory"]),
            Keys.crash: Event(
                "The system reported a crash", category: "diagnostics", level: .error,
                publicFields: ["appVersion", "begin", "end", "exceptionType", "signal"]),
            Keys.hang: Event(
                "The system reported a hang", category: "diagnostics", level: .error,
                publicFields: ["appVersion", "begin", "end", "hangDuration"]),
        ])

    /// The keys of the events in `catalog`.
    public enum Keys {
        public static let metrics = "metrickit.metrics"
        public static let crash = "metrickit.crash"
        public static let hang = "metrickit.hang"
    }

    private let stratum: Stratum

    /// Adds this source's catalog to `stratum`, which publishes every report it receives.
    public init(stratum: Stratum) throws {
        try stratum.add(Self.catalog)
        self.stratum = stratum
    }

    /// Asks MetricKit to deliver reports to this source from now on.
    public func start() {
        MXMetricManager.shared.add(self)
    }

    /// Publishes one metric report, given as MetricKit's JSON. Returns how many events it
    /// published, which is zero for JSON that is not a report.
    @discardableResult
    public func receive(metricReport json: Data) -> Int {
        guard let report = MetricReport(json: json) else { return 0 }
        stratum.publish(Keys.metrics, fields: report.fields)
        return 1
    }

    /// Publishes one event for each crash and hang in a diagnostic report, given as
    /// MetricKit's JSON. Returns how many events it published.
    @discardableResult
    public func receive(diagnosticReport json: Data) -> Int {
        guard let report = DiagnosticReport(json: json) else { return 0 }
        for crash in report.crashes { stratum.publish(Keys.crash, fields: crash) }
        for hang in report.hangs { stratum.publish(Keys.hang, fields: hang) }
        return report.crashes.count + report.hangs.count
    }
}

extension MetricKitSource: MXMetricManagerSubscriber {
    public func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads { receive(metricReport: payload.jsonRepresentation()) }
    }

    public func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads { receive(diagnosticReport: payload.jsonRepresentation()) }
    }
}
