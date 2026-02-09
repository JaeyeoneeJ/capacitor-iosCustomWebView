// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JaeyeoneeCapacitorIosWebview",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "JaeyeoneeCapacitorIosWebview",
            targets: ["JaeyeoneeCapacitorIosWebview"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "JaeyeoneeCapacitorIosWebview",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CustomWebViewPlugin"),
        .testTarget(
            name: "JaeyeoneeCapacitorIosWebviewTests",
            dependencies: ["JaeyeoneeCapacitorIosWebview"],
            path: "ios/Tests/CustomWebViewPluginTests")
    ]
)