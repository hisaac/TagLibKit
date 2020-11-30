// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "TagLibKit",
	products: [
		.library(
			name: "TagLibKit",
			targets: ["TagLibKit"]
		),
	],
	targets: [
		.target(
			name: "TagLibKit",
			dependencies: ["TagLib"]
		),
		.binaryTarget(
			name: "TagLib",
			path: "Frameworks/tag.xcframework"
		),
		.testTarget(
			name: "TagLibKitTests",
			dependencies: ["TagLibKit"]
		),
	]
)
