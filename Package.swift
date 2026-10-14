// swift-tools-version:5.9
import PackageDescription

// Swift port of the Objective-C LGMRomanNumber library (which stays in LGMRomanNumber/).
let package = Package(
    name: "LGMRomanNumber",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [.library(name: "LGMRomanNumberSwift", targets: ["LGMRomanNumberSwift"])],
    targets: [
        .target(name: "LGMRomanNumberSwift"),
        // Line-oriented driver used only by the equivalence harness (Harness/).
        .executableTarget(name: "roman-cli", dependencies: ["LGMRomanNumberSwift"]),
        .testTarget(name: "LGMRomanNumberSwiftTests", dependencies: ["LGMRomanNumberSwift"]),
    ]
)
