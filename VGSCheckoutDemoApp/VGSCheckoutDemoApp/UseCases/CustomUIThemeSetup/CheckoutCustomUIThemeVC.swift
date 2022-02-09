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
	case font(_ font: UIFont, _ textSample: String)
	case color(_ color: UIColor)
}

struct CheckoutUIThemeItem {
	let name: String
	let optionDescription: String
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

	var currentSelectedIndexPath: IndexPath? = nil

	// MARK: - Vars

	fileprivate let buttonContainerView = DemoInsetContainerView(frame: .zero)
	fileprivate let button = UIButton(frame: .zero)

	/// Table view.
	fileprivate let tableView = UITableView(frame: .zero)

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.paddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

		button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		buttonContainerView.addContentView(button)

		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true

		view.addSubview(buttonContainerView)
		button.backgroundColor = .systemBlue
		button.setTitle("Start checkout", for: .normal)
		buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true

		button.addTarget(self, action: #selector(startCheckout), for: .touchUpInside)
	}

	// MARK: - Helpers

	/// Setups table view.
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		view.addSubview(tableView)
		tableView.checkoutDemo_constraintViewToSuperviewEdges()

		tableView.register(CheckoutCustomThemeColorOptionCell.self, forCellReuseIdentifier: CheckoutCustomThemeColorOptionCell.cellIdentifier)
		tableView.register(CheckoutCustomThemeFontOptionCell.self, forCellReuseIdentifier: CheckoutCustomThemeFontOptionCell.cellIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
		tableView.reloadData()
	}

	var vgsCheckout: VGSCheckout?

	@objc private func startCheckout() {
		var checkoutConfiguration = VGSCheckoutCustomConfiguration(vaultID: DemoAppConfiguration.shared.vaultId, environment: DemoAppConfiguration.shared.environment)

		checkoutConfiguration.cardHolderFieldOptions.fieldNameType = .single("cardHolder_name")
		checkoutConfiguration.cardNumberFieldOptions.fieldName = "card_number"
		checkoutConfiguration.expirationDateFieldOptions.fieldName = "exp_data"
		checkoutConfiguration.cvcFieldOptions.fieldName = "card_cvc"

		checkoutConfiguration.billingAddressVisibility = .visible

		checkoutConfiguration.billingAddressCountryFieldOptions.fieldName = "billing_address.country"
		checkoutConfiguration.billingAddressCityFieldOptions.fieldName = "billing_address.city"
		checkoutConfiguration.billingAddressLine1FieldOptions.fieldName = "billing_address.addressLine1"
		checkoutConfiguration.billingAddressLine2FieldOptions.fieldName = "billing_address.addressLine2"
		checkoutConfiguration.billingAddressPostalCodeFieldOptions.fieldName = "billing_address.postal_code"

		// Produce nested json for fields with `.` notation.
		checkoutConfiguration.routeConfiguration.requestOptions.mergePolicy = .nestedJSON

		checkoutConfiguration.routeConfiguration.path = "post"
		checkoutConfiguration.uiTheme = CheckoutUIThemeDataSourceProvider.provideNewTheme(from: dataSource)

		// Update configuration for UITests cases.
//		UITestsConfigurationManager.updateCustomCheckoutConfigurationForUITests(&checkoutConfiguration)

		/* Set custom date user input/output JSON format.

		checkoutConfiguration.expirationDateFieldOptions.inputDateFormat = .shortYearThenMonth
		checkoutConfiguration.expirationDateFieldOptions.outputDateFormat = .longYearThenMonth

		let expDateSerializer = VGSCheckoutExpDateSeparateSerializer(monthFieldName: "card_date.month", yearFieldName: "card_date.year")
		checkoutConfiguration.expirationDateFieldOptions.serializers = [expDateSerializer]
		*/

		// Init Checkout with vault and ID.
		vgsCheckout = VGSCheckout(configuration: checkoutConfiguration)

		//VGSPaymentCards.visa.formatPattern = "#### #### #### ####"

		/// Change default valid card number lengthes
//		VGSPaymentCards.visa.cardNumberLengths = [16]
//		/// Change default format pattern
//		VGSPaymentCards.visa.formatPattern = "#### #### #### ####"

		// Present checkout configuration.
		vgsCheckout?.present(from: self)
	}
}

// MARK: - UITableViewDelegate

/// no:doc
extension CheckoutCustomUIThemeVC: UITableViewDelegate {

	/// no:doc
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = dataSource[indexPath.section].items[indexPath.row]
		currentSelectedIndexPath = indexPath

		switch item.option {
		case .color(let color):
			break
		case .font(let font, let textSample):
			if #available(iOS 13.0, *) {
				let vc = UIFontPickerViewController()
				vc.delegate = self
				present(vc, animated: true)
			} else {
				// Fallback on earlier versions
			}
		}
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

		switch item.option {
		case .color(let color):
			let cell: CheckoutCustomThemeColorOptionCell = tableView.dequeue(cellForRowAt: indexPath)

			cell.configureWithColorOption(with: color, optionName: item.name, optionDescription: item.optionDescription)

			return cell
		case .font(let font, let textSample):
			let cell: CheckoutCustomThemeFontOptionCell = tableView.dequeue(cellForRowAt: indexPath)
			cell.configureWithFontOption(with: font, optionName: item.name, optionDescription: item.optionDescription, textSample: textSample)

			return cell
		}
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
		let textFieldTextColorItem = CheckoutUIThemeItem(name: "Text field text color", optionDescription: "The text color of the textfield.", option: textFieldTextColorOption)

		let textFieldTextFont = uiTheme.textFieldTextFont
		let textFieldTextFontOption = CheckoutUIThemeOption.font(textFieldTextFont, "4111 1111 1111 1111")
		let textFieldTextFontItem = CheckoutUIThemeItem(name: "Text field text font", optionDescription: "The text font of the textfield.", option: textFieldTextFontOption)

		return CheckoutCustomUIThemeSection(title: "Text field UI theme options", items: [textFieldTextColorItem, textFieldTextFontItem])
	}

	static func provideNewTheme(from dataSource: [CheckoutCustomUIThemeSection]) -> VGSCheckoutThemeProtocol {
		var theme = VGSCheckoutDefaultTheme()

		for section in dataSource {
			if section.title == "Text field UI theme options" {
				for item in section.items {
					if item.name == "Text field text font" {
						switch item.option {
						case .font(let font, _):
							theme.textFieldTextFont = font
						case .color(let color):
							break
						}
					}
				}
			}
		}

		return theme
	}
}

class CheckoutCustomThemeColorOptionCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate lazy var optionNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	fileprivate lazy var optionDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	fileprivate lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill

		stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	fileprivate lazy var lightModeColorView: ThemeOptionItemColorDetailView = {
		let view = ThemeOptionItemColorDetailView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	fileprivate lazy var darkModeColorView: ThemeOptionItemColorDetailView = {
		let view = ThemeOptionItemColorDetailView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	private func setupUI() {
		addSubview(verticalStackView)
		verticalStackView.checkoutDemo_constraintViewToSuperviewEdges()

		verticalStackView.addArrangedSubview(optionNameLabel)
		verticalStackView.addArrangedSubview(optionDescriptionLabel)
		verticalStackView.addArrangedSubview(lightModeColorView)
		verticalStackView.addArrangedSubview(darkModeColorView)
	}

	func configureWithColorOption(with color: UIColor, optionName: String, optionDescription: String) {
		optionNameLabel.text = optionName
		optionDescriptionLabel.text = optionDescription

		lightModeColorView.configure(with: color, mode: .light, name: optionName)
		darkModeColorView.configure(with: color, mode: .dark, name: optionName)
	}
}

/// Payment option item view.
internal class ThemeOptionItemColorDetailView: UIView {

	enum Mode {
		case light
		case dark

		var title: String {
			switch self {
			case .light:
				return "light mode"
			case .dark:
				return "dark mode"
			}
		}

		var color: UIColor {
			switch self {
			case .light:
				return UIColor(demoHexString: "FFFFFF")
			case .dark:
				return UIColor(demoHexString: "000000")
			}
		}
	}

	fileprivate lazy var optionNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	/// Stack view.
	fileprivate lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill

		return stackView
	}()

	/// Picked color container view.
	fileprivate lazy var pickedColorContainerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		view.heightAnchor.constraint(equalToConstant: 44).isActive = true
		view.widthAnchor.constraint(equalToConstant: 44).isActive = true

		view.layer.borderColor = UIColor.green.cgColor
		view.layer.borderWidth = 1

		return view
	}()

	fileprivate lazy var pickedColorView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		view.heightAnchor.constraint(equalToConstant: 32).isActive = true
		view.widthAnchor.constraint(equalToConstant: 32).isActive = true

		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true

		return view
	}()

	init() {
		super.init(frame: .zero)
		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	/// Setup UI.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(optionNameLabel)
		let emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		stackView.addArrangedSubview(emptyView)
		stackView.addArrangedSubview(pickedColorContainerView)

		pickedColorContainerView.addSubview(pickedColorView)
		pickedColorView.centerXAnchor.constraint(equalTo: pickedColorContainerView.centerXAnchor).isActive = true
		pickedColorView.centerYAnchor.constraint(equalTo: pickedColorContainerView.centerYAnchor).isActive = true
	}

	func configure(with color: UIColor, mode: ThemeOptionItemColorDetailView.Mode, name: String) {
		var text = "Color in light mode: \(color.toHexString())"
		pickedColorContainerView.backgroundColor = mode.color
		pickedColorView.backgroundColor = color

		switch mode {
		case .dark:
			if #available(iOS 13.0, *) {
				pickedColorContainerView.overrideUserInterfaceStyle = .dark
			} else {
				// Fallback on earlier versions
			}

			var colorText = color.toHexString()
			if #available(iOS 13.0, *) {
				colorText = color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)).toHexString()
			} else {
				// Fallback on earlier versions
			}
			text = "Color in dark mode: \(colorText)"
		case .light:
			if #available(iOS 13.0, *) {
				pickedColorContainerView.overrideUserInterfaceStyle = .light
			} else {
				// Fallback on earlier versions
			}
			var colorText = color.toHexString()
			if #available(iOS 13.0, *) {
				colorText = color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).toHexString()
			} else {
				// Fallback on earlier versions
			}
			text = "Color in light mode: \(colorText)"
		}

		optionNameLabel.text = text
	}
}

extension UITableViewCell {
	static var cellIdentifier: String {
		return "\(self)"
	}
}

// swiftlint:disable all

internal extension UITableView {
		func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
			return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
		}
}



extension UIColor {
			func toHexString() -> String {
					var r:CGFloat = 0
					var g:CGFloat = 0
					var b:CGFloat = 0
					var a:CGFloat = 0

					getRed(&r, green: &g, blue: &b, alpha: &a)

					let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

					return String(format:"#%06x", rgb)
			}
	}

// swiftlint:enable all

class CheckoutCustomThemeFontOptionCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate lazy var optionNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	fileprivate lazy var optionDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	fileprivate lazy var fontDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	fileprivate lazy var textSampleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	fileprivate lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.spacing = 4
		stackView.alignment = .fill

		return stackView
	}()

	private func setupUI() {
		addSubview(verticalStackView)
		verticalStackView.checkoutDemo_constraintViewToSuperviewEdges()

		verticalStackView.addArrangedSubview(optionNameLabel)
		verticalStackView.addArrangedSubview(optionDescriptionLabel)
		verticalStackView.addArrangedSubview(fontDescriptionLabel)
		verticalStackView.addArrangedSubview(textSampleLabel)
	}

	func configureWithFontOption(with font: UIFont, optionName: String, optionDescription: String, textSample: String) {
		optionNameLabel.text = optionName
		optionDescriptionLabel.text = optionDescription
		fontDescriptionLabel.text = "Font family: \(font.familyName) size: \(font.pointSize)"
		textSampleLabel.text = textSample
		textSampleLabel.font = font
	}
}

extension CheckoutCustomUIThemeVC: UIFontPickerViewControllerDelegate {
	@available(iOS 13.0, *)
	func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
	guard let descriptor = viewController.selectedFontDescriptor else { return }
		let newFont = UIFont(descriptor: descriptor, size: 16)
		guard let indexPath = currentSelectedIndexPath else {return}
		var itemToUpdate = dataSource[indexPath.section].items[indexPath.row]
		switch itemToUpdate.option {
		case .font(let font, let text):
			let newOption = CheckoutUIThemeOption.font(newFont, text)
			dataSource[indexPath.section].items[indexPath.row] = CheckoutUIThemeItem(name: itemToUpdate.name, optionDescription: itemToUpdate.optionDescription, option: newOption)
		case .color:
			break
		}
	}
}
