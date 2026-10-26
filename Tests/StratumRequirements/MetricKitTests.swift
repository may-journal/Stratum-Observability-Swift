import Foundation
import Stratum
import StratumMetricKit
import Testing

/// Requirement 0005: publishing the reports MetricKit delivers. The system delivers reports
/// on its own schedule, so each test replays one saved in MetricKit's JSON shape.
extension Requirements {
    @Suite struct MetricKit {
        /// The saved report named `name`, from the Reports folder.
        func report(_ name: String) throws -> Data {
            let url = try #require(
                Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Reports")
            )
            return try Data(contentsOf: url)
        }

        @Test func test0005_1() throws {
            let recorder = Recorder()
            let source = try MetricKitSource(stratum: notesStratum([recorder]))
            source.receive(metricReport: try report("metric-report"))
            let snapshot = try #require(recorder.snapshots.first)
            #expect(snapshot.key == MetricKitSource.Keys.metrics)
            #expect(snapshot.publicFields["begin"] == "2026-10-25 00:00:00 +0000")
            #expect(snapshot.publicFields["peakMemory"] == "182400 kB")
        }

        @Test func test0005_2() throws {
            let recorder = Recorder()
            let source = try MetricKitSource(stratum: notesStratum([recorder]))
            source.receive(diagnosticReport: try report("diagnostic-report"))
            #expect(
                recorder.snapshots.map(\.key) == [
                    MetricKitSource.Keys.crash, MetricKitSource.Keys.hang,
                ])
            #expect(recorder.snapshots.last?.publicFields["hangDuration"] == "3 sec")
        }

        @Test func test0005_3() throws {
            let recorder = Recorder()
            let source = try MetricKitSource(stratum: notesStratum([recorder]))
            source.receive(metricReport: Data("{\"appVersion\": \"2.1\"}".utf8))
            #expect(recorder.snapshots.isEmpty)
        }
    }
}
