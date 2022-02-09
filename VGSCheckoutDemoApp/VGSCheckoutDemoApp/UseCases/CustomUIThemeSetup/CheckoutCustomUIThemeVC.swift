//
//  CheckoutCustomUIThemeVC.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK

///// Defines UI Theme for text field.
//public protocol VGSCheckoutTextFieldThemeProtocol {
//
//	/// Colors.
//
//	/// The textfield’s background color.
//	var textFieldBackgroundColor: UIColor { get set }
//
//	/// The textfield’s border background color.
//	var textFieldBorderColor: UIColor { get set }
//
//	/// The textfield’s focus state color.
//	var textFieldFocusedColor: UIColor { get set }
//
//	/// The text color of the textfield hint (above the text field).
//	var textFieldHintTextColor: UIColor { get set }
//
//	/// The text color of the textfield.
//	var textFieldTextColor: UIColor { get set }
//
//	/// The textfield’s error color.
//	var textFieldErrorColor: UIColor { get set }
//
//	/// Fonts.
//
//	/// The font of the textfield.
//	var textFieldTextFont: UIFont { get set }
//
//	/// The font of the textfield hint (above the text field).
//	var textFieldHintTextFont: UIFont { get set }
//
//	/// The font of the error label.
//	var textFieldErrorLabelFont: UIFont { get set }
//}

enum CheckoutUIThemeOption {
	case font(_ font: UIFont)
	case color(_ color: UIColor)
}

struct CheckoutUIThemeItem {
	let name: String
	var option: CheckoutUIThemeOption
}

struct CheckoutCustomUIThemeSection {
	let title: String
	var items: [CheckoutUIThemeItem]
}

class CheckoutCustomUIThemeVC: UIViewController {

	/// Checkout data source.
	fileprivate var dataSource: [CheckoutCustomUIThemeSection] = CheckoutUIThemeDataSourceProvider.buildDataSource() {
		didSet {
			tableView.reloadData()
		}
	}

	// MARK: - Vars

	/// Table view.
	fileprivate let tableView = UITableView(frame: .zero)

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	// MARK: - Helpers

	/// Setups table view.
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		view.addSubview(tableView)
		tableView.checkoutDemo_constraintViewToSuperviewEdges()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate

/// no:doc
extension CheckoutCustomUIThemeVC: UITableViewDelegate {

	/// no:doc
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dataSource[section].title
	}
}

// MARK: - UITableViewDataSource

/// no:doc
extension CheckoutCustomUIThemeVC: UITableViewDataSource {

	/// no:doc
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let sectionItem = dataSource[indexPath.section]
		let item = sectionItem.items[indexPath.row]

		let cell = UITableViewCell(style: .default, reuseIdentifier: "id")
		cell.textLabel?.text = item.name
		switch item.option {
		case .color(let color):
			cell.textLabel?.textColor = color
		case .font(let font):
			cell.textLabel?.font = font
		}

		return cell
	}

	/// no:doc
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource[section].items.count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSource.count
	}
}

class CheckoutUIThemeDataSourceProvider {
	static func buildDataSource() -> [CheckoutCustomUIThemeSection] {
		var dataSource = [CheckoutCustomUIThemeSection]()

		dataSource = [buildTextFieldOptionsSection()]

		return dataSource
	}

	static func buildTextFieldOptionsSection() -> CheckoutCustomUIThemeSection {
		let uiTheme = VGSCheckoutDefaultTheme()

		let texctextFieldTextColor = uiTheme.textFieldTextColor
		let textFieldTextColorOption = CheckoutUIThemeOption.color(texctextFieldTextColor)
		let textFieldTextColorItem = CheckoutUIThemeItem(name: "Text field text color", option: textFieldTextColorOption)

		let textFieldTextFont = uiTheme.textFieldTextFont
		let textFieldTextFontOption = CheckoutUIThemeOption.font(textFieldTextFont)
		let textFieldTextFontItem = CheckoutUIThemeItem(name: "Text field text font", option: textFieldTextFontOption)

		return CheckoutCustomUIThemeSection(title: "Text field UI theme options", items: [textFieldTextColorItem, textFieldTextFontItem])
	}
}
