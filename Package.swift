// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFmpegKit",
    platforms: [
        .macOS("10.15.4"),
        .iOS("13.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FFmpegKitiOS",
            type: .dynamic,
            targets: [
                "GDIFFmpegKit"
            ]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(name: "ffmpegkit-ios", path: "ffmpeg-kit/ios/ffmpegkit.xcframework"),
        .binaryTarget(name: "libavcodec-ios", path: "ffmpeg-kit/ios/libavcodec.xcframework"),
        .binaryTarget(name: "libavdevice-ios", path: "ffmpeg-kit/ios/libavdevice.xcframework"),
        .binaryTarget(name: "libavfilter-ios", path: "ffmpeg-kit/ios/libavfilter.xcframework"),
        .binaryTarget(name: "libavformat-ios", path: "ffmpeg-kit/ios/libavformat.xcframework"),
        .binaryTarget(name: "libavutil-ios", path: "ffmpeg-kit/ios/libavutil.xcframework"),
        .binaryTarget(name: "libswresample-ios", path: "ffmpeg-kit/ios/libswresample.xcframework"),
        .binaryTarget(name: "libswscale-ios", path: "ffmpeg-kit/ios/libswscale.xcframework"),

//        .target(
//            name: "Dependencies",
//            linkerSettings: [
//                .linkedLibrary("z"),
//                .linkedLibrary("bz2"),
//                .linkedLibrary("iconv"),
//                .linkedLibrary("c++"),
//            ]
//        ),


        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GDIFFmpegKit",
            dependencies: [
                "ffmpegkit-ios",
                "libavcodec-ios",
                "libavdevice-ios",
                "libavfilter-ios",
                "libavformat-ios",
                "libavutil-ios",
                "libswresample-ios",
                "libswscale-ios",
//                "Dependencies"
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("bz2"),
                .linkedLibrary("iconv"),
                .linkedLibrary("c++"),
            ]
        ),
        .testTarget(
            name: "GDIFFmpegKitiOSTests",
            dependencies: ["GDIFFmpegKit"]),
    ]
)
