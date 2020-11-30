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
		.target(
			name: "TagLib",
			dependencies: [],
			path: "Sources/taglib",
			cxxSettings: [
				.headerSearchPath("3rdparty"),
				.headerSearchPath("include/taglib"),
				.headerSearchPath(""),
				.headerSearchPath("ape"),
				.headerSearchPath("asf"),
				.headerSearchPath("dsdiff"),
				.headerSearchPath("dsf"),
				.headerSearchPath("flac"),
				.headerSearchPath("it"),
				.headerSearchPath("mod"),
				.headerSearchPath("mp4"),
				.headerSearchPath("mpc"),
				.headerSearchPath("mpeg"),
				.headerSearchPath("mpeg/id3v1"),
				.headerSearchPath("mpeg/id3v2"),
				.headerSearchPath("mpeg/id3v2/frames"),
				.headerSearchPath("ogg"),
				.headerSearchPath("ogg/flac"),
				.headerSearchPath("ogg/opus"),
				.headerSearchPath("ogg/speex"),
				.headerSearchPath("ogg/vorbis"),
				.headerSearchPath("riff"),
				.headerSearchPath("riff/aiff"),
				.headerSearchPath("riff/wav"),
				.headerSearchPath("s3m"),
				.headerSearchPath("toolkit"),
				.headerSearchPath("trueaudio"),
				.headerSearchPath("wavpack"),
				.headerSearchPath("xm"),
			]
		),
		.testTarget(
			name: "TagLibKitTests",
			dependencies: ["TagLibKit"]
		),
	]
)
