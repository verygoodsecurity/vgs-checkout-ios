//
//  VGSAddressDataSectionManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds logic for billing addres setup and handling events.
final internal class VGSAddressDataSectionManager: VGSBaseFormSectionProtocol, VGSPlaceholderFormItemViewDelegate, VGSPickerTextFieldSelectionDelegate {

	weak var delegate: VGSFormSectionPresenterDelegate?

	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	internal let validationBehavior: VGSFormValidationBehaviour

	/// Card form view.
	internal let billingAddressFormView: VGSBillingAddressDetailsView

	/// Text field form items in add card section.
	var textFiedFormItems: [VGSTextFieldFormItemProtocol] {
		return billingAddressFormView.formItems
	}

	var vgsTextFields: [VGSTextField] {
		return textFiedFormItems.map({return $0.textField})
	}

	/// Configuration type.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect
//
//	/// Validation manager.
//	internal let formValidationHelper: VGSFormValidationHelper
//
//	/// Autofocus manager.
//	internal let autoFocusManager: VGSFormAutofocusManager

	// MARK: - Initialization

	internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onFocus) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
		self.billingAddressFormView = VGSBillingAddressDetailsView(paymentInstrument: paymentInstrument)
//		self.formValidationHelper = VGSFormValidationHelper(formItems: cardFormView.formItems, validationBehaviour: validationBehavior)
//		self.autoFocusManager = VGSFormAutofocusManager(formItemsManager: VGSFormItemsManager(formItems: cardFormView.formItems))

		buildForm()
	}

	// MARK: - Interface

	internal func buildForm() {
		billingAddressFormView.translatesAutoresizingMaskIntoConstraints = false

		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		case .multiplexing(let multiplexingConfig):
			setupCardForm(with: multiplexingConfig)
		}

		let inputBlackTextColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor {(traits) -> UIColor in
					return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
				}
			} else {
				return .black
			}
		}()

		vgsCollect.textFields.forEach { textField in
			textField.textColor = inputBlackTextColor
			textField.font = UIFont.preferredFont(forTextStyle: .body)
			textField.adjustsFontForContentSizeCategory = true
		  textField.delegate = self
		}

		for item in textFiedFormItems {
			item.formItemView.delegate = self
		}

		statePickerField?.pickerSelectionDelegate = self
		countryPickerField?.pickerSelectionDelegate = self
	}

	// MARK: - Helpers

	private func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: vaultConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	private func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: multiplexingConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	func didTap(in formView: VGSPlaceholderFormItemView) {
		for item in textFiedFormItems {
			if item.formItemView === formView {
				item.textField.becomeFirstResponder()
			}
		}
	}

	/// Update Form Validation State.
	func updateFormState() {
//		if formValidationHelper.isFormValid() {
//			state = .valid
//		} else {
//			state = .invalid
//		}
	}

	var currentSelectedCountry: VGSCountriesISO = .us {
		didSet {

		}
	}

	var currentSelectedState: VGSAddressRegionModel? = nil {
		didSet {

		}
	}

	var countryPickerField: VGSPickerTextField? {
		guard let countryTextField = textFiedFormItems.first(where: {$0.fieldType == .country})?.textField as? VGSPickerTextField else {return nil}

		return countryTextField
	}

	var statePickerField: VGSPickerTextField? {
		guard let stateTextField = textFiedFormItems.first(where: {$0.fieldType == .state})?.textField as? VGSPickerTextField else {return nil}

		return stateTextField
	}

	var currentRegions: [VGSAddressRegionModel] {
		guard let config = countryPickerField?.configuration as? VGSPickerTextFieldConfiguration, let dataSource = config.dataProvider?.dataSource as? VGSRegionsDataSourceProvider else {
			return []
		}

		return dataSource.regions
	}
}

// MARK: - VGSTextFieldDelegate

extension VGSAddressDataSectionManager: VGSTextFieldDelegate {

	func vgsTextFieldDidChange(_ textField: VGSTextField) {
//		updateSecurityCodeFieldIfNeeded(for: textField)
//		formValidationHelper.updateFormViewOnEditingTextField(cardFormView, textField: textField)
		updateFormState()
	}

	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
//		formValidationHelper.updateFormViewOnEndEditingTextField(cardFormView, textField: textField)
		updateFormState()
	}

	func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
//		formValidationHelper.updateFormViewOnEndEditingTextField(cardFormView, textField: textField)
//		autoFocusManager.focusOnEndEditingOnReturn(for: textField)
		updateFormState()
	}

	func pickerAddressDidUpdate(in field: VGSTextField, fieldType: VGSAddCardFormFieldType) {
		guard let pickerField = field as? VGSPickerTextField else {
			return
		}

		switch fieldType {
		case .country:
			break
		case .state:
			break
		default:
			break
		}
	}

	func updateStateField(with countryISO: VGSCountriesISO) {
		guard let stateField = statePickerField else {return}
		switch countryISO {
		case .us:
			if let config = stateField.configuration as? VGSPickerTextFieldConfiguration {
				let regionsDataSource = VGSRegionsDataSourceProvider(with: "US")
				let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
				config.dataProvider = regionsDataSourceProvider
			}
		case .ca:
			if let config = stateField.configuration as? VGSPickerTextFieldConfiguration {
				let regionsDataSource = VGSRegionsDataSourceProvider(with: "CA")
				let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
				config.dataProvider = regionsDataSourceProvider
			}
		default:
			billingAddressFormView.statePickerFormItemView.statePickerTextField.mode = .textField
		}
	}

	func userDidSelectValue(_ textValue: String?, in pickerTextField: VGSPickerTextField) {
		guard let text = textValue else {return}
		if pickerTextField === countryPickerField {
			var currentCode: String = ""

			for region in currentRegions {
				if region.code == text {
					currentCode = region.code
					print("currentCode found \(currentCode)")
				}
			}

			if let newCountry = VGSCountriesISO(rawValue: currentCode) {
				updateStateField(with: newCountry)
			}
		} else if pickerTextField === statePickerField {

		}
	}
}
