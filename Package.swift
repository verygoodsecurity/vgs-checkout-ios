
// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "VGSCheckoutSDK",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v11),
	],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "VGSCheckoutSDK",
			targets: ["VGSCheckoutSDK"])
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "VGSCheckoutSDK",
			exclude: [
				"VGSCheckoutSDK.h",
				"Info.plist"
			], resources: [.process("Resources")]),
		.testTarget(
				name: "VGSCheckoutSDKTests",
				dependencies: ["VGSCheckoutSDK"],
				exclude: [
				"Info.plist",
				"VGSCheckoutSDKTests.xctestplan"
				],
				resources: [.process("Resources")]
		),
	])
