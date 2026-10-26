import Foundation

/// The fields Stratum publishes for each crash and hang in MetricKit's diagnostic report JSON.
struct DiagnosticReport {
    let crashes: [[String: String]]
    let hangs: [[String: String]]

    init?(json: Data) {
        guard let object = Report.object(json), let period = Report.period(object) else {
            return nil
        }
        crashes = Report.diagnostics(
            object["crashDiagnostics"], period: period, keys: ["exceptionType", "signal"])
        hangs = Report.diagnostics(
            object["hangDiagnostics"], period: period, keys: ["hangDuration"])
    }
}
