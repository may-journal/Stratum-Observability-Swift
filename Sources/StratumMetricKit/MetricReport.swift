import Foundation

/// The fields Stratum publishes from MetricKit's metric report JSON.
struct MetricReport {
    let fields: [String: String]

    init?(json: Data) {
        guard let object = Report.object(json), let period = Report.period(object) else {
            return nil
        }
        var fields = period
        fields["appVersion"] = Report.text(object["appVersion"])
        let memory = object["memoryMetrics"] as? [String: Any]
        fields["peakMemory"] = Report.text(memory?["peakMemoryUsage"])
        self.fields = fields
    }
}

/// Reading MetricKit's report JSON, whose values are strings or numbers.
enum Report {
    static func object(_ json: Data) -> [String: Any]? {
        (try? JSONSerialization.jsonObject(with: json)) as? [String: Any]
    }

    /// The report's period, which every report states.
    static func period(_ object: [String: Any]) -> [String: String]? {
        guard let begin = text(object["timeStampBegin"]), let end = text(object["timeStampEnd"])
        else { return nil }
        return ["begin": begin, "end": end]
    }

    /// One field set per diagnostic: the period, its app version, and `keys`.
    static func diagnostics(_ list: Any?, period: [String: String], keys: [String])
        -> [[String: String]]
    {
        let items = list as? [[String: Any]] ?? []
        return items.map { item in
            let meta = item["diagnosticMetaData"] as? [String: Any] ?? [:]
            var fields = period
            for key in keys + ["appVersion"] { fields[key] = text(meta[key]) }
            return fields
        }
    }

    static func text(_ value: Any?) -> String? {
        switch value {
        case let string as String: string
        case let number as NSNumber: number.stringValue
        default: nil
        }
    }
}
