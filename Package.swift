// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Erika",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "Erika", targets: ["Erika"]),
    ],
    targets: [
        .binaryTarget(
            name: "CErika",
            url: "https://github.com/AimesSoft/liberika/releases/download/v0.3.0/erika-swift-core-0.3.0.xcframework.zip",
            checksum: "20416014754e9be92ae53bb54ed70dae31cbb23767fa8fe3b924046dd4081d3b"
        ),
        .target(
            name: "Erika",
            dependencies: ["CErika"],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("ApplicationServices", .when(platforms: [.macOS])),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("CoreAudio", .when(platforms: [.macOS])),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreText"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("Metal"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("VideoToolbox"),
                .linkedLibrary("bz2"),
                .linkedLibrary("iconv"),
                .linkedLibrary("z"),
            ]
        ),
        .testTarget(name: "ErikaTests", dependencies: ["Erika"]),
    ]
)
