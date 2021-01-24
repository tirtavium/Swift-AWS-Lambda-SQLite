// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccountServiceAWS",
    products: [
        .executable(name: "AccountServiceAWS", targets: ["AccountServiceAWS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "0.3.0"),
        .package(url: "https://github.com/soto-project/soto.git", from: "5.0.0")
    ],
    targets: [
        .systemLibrary(
            name: "CSQLite3",
            providers: [
                .apt(["libsqlite3-dev"]),
                .brew(["sqlite3"])
            ]
        ),
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AccountServiceAWS",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "SotoS3", package: "soto"),
                .target(name: "CSQLite3")],
            resources: [
                 .copy("DB/accountData.db")
            ]
        ),
        .testTarget(
            name: "AccountServiceAWSTests",
            dependencies: ["AccountServiceAWS"]),
    ]
)
