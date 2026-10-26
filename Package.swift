// swift-tools-version: 6.2
// Stratum's core and its plugins, in the build order Plan #1 set. See docs/architecture/04-code.md.
import PackageDescription

let package = Package(
    name: "Stratum",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "Stratum", targets: ["Stratum"]),
        .library(name: "StratumOSLog", targets: ["StratumOSLog"]),
        .library(name: "StratumMetricKit", targets: ["StratumMetricKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/may-journal/apple-ui-testing-library", from: "1.7.2")
    ],
    targets: [
        .target(name: "Stratum"),
        .target(name: "StratumOSLog", dependencies: ["Stratum"]),
        .target(name: "StratumMetricKit", dependencies: ["Stratum"]),
        .testTarget(
            name: "StratumRequirements",
            dependencies: [
                "Stratum", "StratumOSLog", "StratumMetricKit",
                .product(name: "UITestingLibrary", package: "apple-ui-testing-library"),
            ],
            resources: [.copy("Reports")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
