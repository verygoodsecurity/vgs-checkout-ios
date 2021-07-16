//
//  VGSCardDataSectionManager.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form section delegate protocol.
internal protocol VGSFormSectionPresenterDelegate: AnyObject {
	func stateDidChange(_ state: VGSFormSectionState)
}

/// Base protocol for form section.
internal protocol VGSBaseFormSectionProtocol {
	var vgsTextFields: [VGSTextField] {get}
}

/// Form section state.
internal enum VGSFormSectionState {
	case valid
	case invalid
}

/// Defines validation behavior.
internal enum VGSFormValidationBehaviour {
	case onFocus
	case onTextChange
}

/// Holds logic for card form setup and handling events.
final internal class VGSCardDataSectionManager: VGSBaseFormSectionProtocol, VGSPlaceholderFormItemViewDelegate {  
  
	weak var delegate: VGSFormSectionPresenterDelegate?

	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	internal let validationBehavior: VGSFormValidationBehaviour

	/// Card form view.
	internal let cardFormView: VGSCardDetailsFormView

	/// Text field form items in add card section.
	var textFiedFormItems: [VGSTextFieldFormItemProtocol] {
		return cardFormView.formItems
	}

	var vgsTextFields: [VGSTextField] {
		return textFiedFormItems.map({return $0.textField})
	}

	/// Configuration type.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

  /// Validation manager.
	internal let formValidationHelper: VGSFormValidationHelper

	/// Autofocus manager.
	internal let autoFocusManager: VGSFormAutofocusManager
  
	// MARK: - Initialization

internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onFocus, uiTheme: VGSCheckoutThemeProtocol) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
    self.cardFormView = VGSCardDetailsFormView(paymentInstrument: paymentInstrument, uiTheme: uiTheme)
		self.formValidationHelper = VGSFormValidationHelper(formItems: cardFormView.formItems, validationBehaviour: validationBehavior)
		self.autoFocusManager = VGSFormAutofocusManager(formItemsManager: VGSFormItemsManager(formItems: cardFormView.formItems))

		buildForm()
	}

  
	// MARK: - Interface

	internal func buildForm() {
		cardFormView.translatesAutoresizingMaskIntoConstraints = false
		
		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		case .multiplexing(let multiplexingConfig):
			setupCardForm(with: multiplexingConfig)
		}

//		let inputBlackTextColor: UIColor = {
//			if #available(iOS 13.0, *) {
//				return UIColor {(traits) -> UIColor in
//					return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
//				}
//			} else {
//				return .black
//			}
//		}()
    
    for item in textFiedFormItems {
      item.formItemView.delegate = self
      item.textField.delegate = self
    }
	}
  
  

	// MARK: - Helpers

	private func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: vaultConfiguration, vgsCollect: vgsCollect, cardFormView: cardFormView)
	}

	private func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: multiplexingConfiguration, vgsCollect: vgsCollect, cardFormView: cardFormView)
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
    if formValidationHelper.isFormValid() {
      state = .valid
    } else {
      state = .invalid
    }
  }
}

// MARK: - VGSTextFieldDelegate

extension VGSCardDataSectionManager: VGSTextFieldDelegate {
  
  func vgsTextFieldDidChange(_ textField: VGSTextField) {
    updateSecurityCodeFieldIfNeeded(for: textField)
    formValidationHelper.updateFormViewOnEditingTextField(cardFormView, textField: textField)
    updateFormState()
  }
  
	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
		formValidationHelper.updateFormViewOnEndEditingTextField(cardFormView, textField: textField)
    updateFormState()
	}

	func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
    formValidationHelper.updateFormViewOnEndEditingTextField(cardFormView, textField: textField)
		autoFocusManager.focusOnEndEditingOnReturn(for: textField)
    updateFormState()
	}
}

// MARK: - CVC Helpers

extension VGSCardDataSectionManager {
  
  /// Check if CardBrand is changed and update cvc validation state if needed.
  internal func updateSecurityCodeFieldIfNeeded(for editingTextField: VGSTextField) {
    guard editingTextField.configuration?.type == .cardNumber,
       let cardState = editingTextField.state as? CardState,
       let cvcField = vgsTextFields.first(where: { $0.configuration?.type == .cvc}) else {
      return
    }
    // Update Field Placeholder
    updateCVCFieldPlaceholder(cvcField, cardBrand: cardState.cardBrand)
    // Update UI for new CVC Field State
    formValidationHelper.updateFormViewOnEndEditingTextField(cardFormView, textField: cvcField)
  }

  private func updateCVCFieldPlaceholder(_ field: VGSTextField, cardBrand: VGSCheckoutPaymentCards.CardBrand) {
     switch cardBrand {
     case .amex:
       field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")
     default:
      field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")
     }
   }
}
