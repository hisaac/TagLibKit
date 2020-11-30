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
			dependencies: ["TagLib"],
			path: "Sources/TaglibWrapper",
			exclude: ["README.md"],
			publicHeadersPath: nil
		),
		.target(
			name: "TagLib",
			dependencies: [],
			path: "Sources/taglib/taglib",
			exclude: [
				"cmake_install.cmake",
				"CMakeLists.txt",
				"libtag.a",
				"Makefile",
				"taglib_config.h.cmake",
				"ape/ape-tag-format.txt",
				"bin/",
				"CMakeFiles/",
				"include/taglib/tlist.tcc",
				"include/taglib/tmap.tcc",
				"lib/",
				"mpeg/id3v2/id3v2.2.0.txt",
				"mpeg/id3v2/id3v2.3.0.txt",
				"mpeg/id3v2/id3v2.4.0-frames.txt",
				"mpeg/id3v2/id3v2.4.0-structure.txt",
				"toolkit/tlist.tcc",
				"toolkit/tmap.tcc",
			],
			// To rebuild the public headers, from the root of the taglib repo, run:
			//   cmake -DCMAKE_INSTALL_PREFIX=./taglib -DCMAKE_BUILD_TYPE=Release .
			//   make
			//   make install
			cxxSettings: [
				.headerSearchPath("../3rdparty"),
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
