//
//  VGSCardDataSectionViewModel.swift
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
	case onSubmit
	case onEdit
}

/// Holds logic for card form setup and handling events.
final internal class VGSCardDataSectionViewModel: VGSBaseFormSectionProtocol, VGSPlaceholderFieldViewDelegate {  
  
	weak var delegate: VGSFormSectionPresenterDelegate?

	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	/// Validation behaviour.
	internal let validationBehavior: VGSFormValidationBehaviour

	/// Card form view.
	internal let cardDetailsSectionView: VGSCardDetailsSectionView

	/// Text field form items in add card section.
	var fieldViews: [VGSTextFieldViewProtocol] {
		return cardDetailsSectionView.fieldViews
	}

	/// Text fields.
	var vgsTextFields: [VGSTextField] {
		return fieldViews.map({return $0.textField})
	}

	/// Configuration type.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

  /// Validation manager.
	internal let formValidationHelper: VGSFormValidationHelper

	/// Autofocus manager.
	internal let autoFocusManager: VGSFieldAutofocusManager
  
	// MARK: - Initialization

	internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onSubmit, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
    self.cardDetailsSectionView = VGSCardDetailsSectionView(paymentInstrument: paymentInstrument, uiTheme: uiTheme)
		self.formValidationHelper = formValidationHelper
		self.autoFocusManager = autoFocusManager

		buildForm()
	}

	// MARK: - Interface

	/// Builds form.
	internal func buildForm() {
		cardDetailsSectionView.translatesAutoresizingMaskIntoConstraints = false
		
		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		case .multiplexing(let multiplexingConfig):
			setupCardForm(with: multiplexingConfig)
		}

		for item in fieldViews {
			item.placeholderView.delegate = self
			item.delegate = self
		}
	}

	// MARK: - Helpers

	/// Setup card form with vault config.
	/// - Parameter vaultConfiguration: `VGSCheckoutConfiguration` object, vault configuration.
	private func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: vaultConfiguration, vgsCollect: vgsCollect, cardSectionView: cardDetailsSectionView)
	}

	/// Setup card form with multiplexing config.
	/// - Parameter multiplexingConfiguration: `VGSCheckoutMultiplexingConfiguration` object, multiplexing configuration.
	private func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: multiplexingConfiguration, vgsCollect: vgsCollect, cardSectionView: cardDetailsSectionView)
	}

	/// Handles tap in form views to make textField first responder when tap is outside the textField.
	func didTap(in formView: VGSPlaceholderFieldView) {
		for item in fieldViews {
			if item.placeholderView === formView {
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

extension VGSCardDataSectionViewModel: VGSTextFieldViewDelegate {
    func vgsFieldViewDidBeginEditing(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnBeginEditingTextField(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewDidEndEditing(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnEndEditing(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewDidEndEditingOnReturn(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnEndEditing(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewdDidChange(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnTextChangeInTextField(fieldView)
        updateSecurityCodeFieldIfNeeded(for: fieldView)
        updateFormState()
    }
}

// MARK: - CVC Helpers

extension VGSCardDataSectionViewModel {
  
  /// Check if CardBrand is changed and update cvc validation state if needed.
  internal func updateSecurityCodeFieldIfNeeded(for textView: VGSTextFieldViewProtocol) {
    guard textView.fieldType == .cardNumber,
          let cardState = textView.textField.state as? CardState,
          let cvcFieldView = fieldViews.first(where: {$0.fieldType == .cvc}) else {
        return
    }
    // Update Field Placeholder
    updateCVCFieldPlaceholder(cvcFieldView.textField, cardBrand: cardState.cardBrand)
  }

  private func updateCVCFieldPlaceholder(_ field: VGSTextField, cardBrand: VGSCheckoutPaymentCards.CardBrand) {
     switch cardBrand {
     case .amex:
       field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code_amex")
     default:
      field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code")
     }
   }
}
