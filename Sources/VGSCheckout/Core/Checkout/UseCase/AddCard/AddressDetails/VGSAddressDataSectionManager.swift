//
//  VGSAddressDataSectionManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds logic for billing addres setup and handling events.
final internal class VGSAddressDataSectionManager: VGSBaseFormSectionProtocol, VGSPlaceholderFormItemViewDelegate {

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
		guard let stateField = textFiedFormItems.first(where: {$0.fieldType == .state})?.textField as? VGSPickerTextField else {return}
		switch countryISO {
		case .us:
			break
		default:
			billingAddressFormView.statePickerFormItemView.statePickerTextField.mode = .textField
		}
	}
}
