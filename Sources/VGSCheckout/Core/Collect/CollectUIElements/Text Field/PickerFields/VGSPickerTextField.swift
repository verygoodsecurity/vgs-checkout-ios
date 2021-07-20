//
//  VGSPickerTextField.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

internal protocol VGSPickerTextFieldSelectionDelegate: AnyObject {
	func userDidSelectValue(_ textValue: String?, in pickerTextField: VGSPickerTextField)
}

/// Text field with picker view input.
internal class VGSPickerTextField: VGSTextField {

	/// Selected value from picker (can mismatch with actual displayed text - like we need to send country code instead of displayed name).
	fileprivate var selectedPickerValue: String?

	/// Selected output value (can mismatch with actual displayed text).
	internal var selectedOutputValue: String? {
		switch mode {
		case .textField:
			// For text field use output text (displayed text).
			return getOutputText()
		case .picker:
			// Use selected value from picker.
			return selectedPickerValue
		}
	}

	/// Defines input mode type.
	internal enum InputMode {

		/// Picker view input.
		case picker

		/// Text field input.
		case textField
	}

	/// Input mode.
	internal var mode: InputMode = InputMode.picker {
		didSet {
			updateUI(for: mode)
		}
	}

	/// Previous tint color.
	internal var previousTintColor: UIColor?

	/// Picker delegate.
	internal weak var pickerSelectionDelegate: VGSPickerTextFieldSelectionDelegate?

	/// Picker view.
	internal let pickerView: UIPickerView = UIPickerView(frame: .zero)

	// MARK: - Override

	/// Main initialization setup.
	override func mainInitialization() {
		super.mainInitialization()

		updateUI(for: .picker)
	}

	override var configuration: VGSConfiguration? {
		didSet {
			setupPickerView()
		}
	}

	/// Force select first row.
	internal func selectFirstRow() {
		pickerView.selectRow(0, inComponent: 0, animated: false)
		pickerView(pickerView, didSelectRow: 0, inComponent: 0)
	}

	/// Setup toolbar.
	internal func setupToolBar() {
		let toolbar = UIToolbar()
		let doneButtonTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_picker_toolbar_done_button_title")
		let doneButton = UIBarButtonItem(title: doneButtonTitle, style: .plain,
																		 target: self, action: #selector(self.doneButtonDidTap))
		toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
		toolbar.sizeToFit()
		toolbar.setContentHuggingPriority(.defaultLow, for: .horizontal)
		textField.inputAccessoryView = toolbar
	}

	/// Setup right view.
	private func setupRightView() {
		let image = UIImage(named: "picker_arrow_down", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)
		textField.rightView = UIImageView(image: image)
		textField.rightViewMode = .always
	}

	/// Setup picker view.
	internal func setupPickerView() {
		pickerView.delegate = self
		if let pickerConfiguration = configuration as? VGSPickerTextFieldConfiguration {
			pickerView.dataSource = pickerConfiguration.dataProvider
		}
		textField.inputView = pickerView
	}

	/// Update UI for input mode.
	/// - Parameter mode: `InputMode` object, input mode.
	internal func updateUI(for mode: InputMode) {
		switch mode {
		case .picker:
			// Hide caret for picker view text field.
			isCaretHidden = true

			setupToolBar()
			setupPickerView()
			setupRightView()

			/// Disable autocorrection and tintColor for picker.
			previousTintColor = tintColor
			tintColor = .clear
			autocorrectionType = .no
		case .textField:
			// Hide caret for picker view text field.
			isCaretHidden = false
			textField.inputView = nil
			autocorrectionType = .no
			tintColor = previousTintColor
			textField.rightViewMode = .never
		}
	}

	// MARK: - Actions

	/// Handle tap on Done button action.
	@objc func doneButtonDidTap() {
		resignFirstResponder()
	}
}

// MARK: - UIPickerViewDelegate

extension VGSPickerTextField: UIPickerViewDelegate {
	func pickerView(
		_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int
	) -> NSAttributedString? {
		guard let pickerConfiguration = configuration as? VGSPickerTextFieldConfiguration else {return nil}
		guard let title = pickerConfiguration.dataProvider?.dataSource.pickerField(self, titleForRow: row) else {
			return nil
		}

		return NSAttributedString(
			string: title, attributes: [.font: font ?? UIFont.preferredFont(forTextStyle: .body)])
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let pickerConfiguration = configuration as? VGSPickerTextFieldConfiguration else {return}
		let selectedText = pickerConfiguration.dataProvider?.dataSource.pickerField(self, titleForRow: row)
		textField.secureText = selectedText
		selectedPickerValue = pickerConfiguration.dataProvider?.dataSource.pickerField(self, selectedValueForRow: row)

		pickerSelectionDelegate?.userDidSelectValue(selectedText, in: self)

		placeholder = nil
	}
}

/// A class responsible for configuration `VGSTextField` with `fieldType = .none`. Extends `VGSConfiguration` class.
internal final class VGSPickerTextFieldConfiguration: VGSConfiguration {

	/// Data provider for picker view.
	internal var dataProvider: VGSPickerDataSourceProvider?

	/// `FieldType.expDate` type of `VGSTextField` configuration.
	override internal var type: FieldType {
		get { return .none }
		set {}
	}
}

/// `UIPickerViewDataSource` dataSource provider.
internal class VGSPickerDataSourceProvider: NSObject, UIPickerViewDataSource {

	/// Data source for picker text field.
	internal let dataSource: VGSPickerTextFieldDataSourceProtocol

	/// Initialization.
	/// - Parameter dataSource: `VGSPickerTextFieldDataSourceProtocol` object, fields data source.
	init(dataSource: VGSPickerTextFieldDataSourceProtocol) {
		self.dataSource = dataSource
	}

	// MARK: - UIPickerViewDataSource

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataSource.numberOfRows()
	}
}

/// Data source for VGS Picker text field.
internal protocol VGSPickerTextFieldDataSourceProtocol {
	func numberOfRows() -> Int
	func pickerField(_ pickerField: VGSPickerTextField, titleForRow row: Int) -> String?
	func pickerField(_ pickerField: VGSPickerTextField, selectedValueForRow row: Int)
	-> String?
}
