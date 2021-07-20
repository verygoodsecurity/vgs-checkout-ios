
// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "VGSCheckout",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v11),
	],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "VGSCheckout",
			targets: ["VGSCheckout"]),
		.library(
				name: "VGSCheckoutCardIOScanner",
				targets: ["VGSCheckoutCardIOScanner"])
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "VGSCheckout",
			exclude: [
				"VGSCheckout.h",
				"Info.plist"
			], resources: [.process("Resources/VGSCanadaRegions.json"), .process("Resources/VGSVGSUnitedStatesRegions.json")]),
		.target(
			name: "VGSCheckoutCardIOScanner",
			path: "Sources/VGSCheckoutCardIOScanner/",
			exclude: [
				"CheckoutCardIOScanner.h",
				"Info.plist",
			]),
		.testTarget(
				name: "VGSCheckoutTests",
				dependencies: ["VGSCheckout"],
				exclude: [
				"Info.plist",
				"VGSCheckoutTests.xctestplan"
				],
				resources: [.process("Resources")]
		),
	])
