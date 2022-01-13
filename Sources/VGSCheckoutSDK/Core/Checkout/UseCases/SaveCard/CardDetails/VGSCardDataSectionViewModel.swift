//
//  VGSCardDataSectionViewModel.swift
//  VGSCheckoutSDK
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

/// Defines form validation behavior.
public enum VGSCheckoutFormValidationBehaviour {

	/// Validate fields and display errors on submit.
	case onSubmit

	/// Validate fields and display errors on end editing. Revalidate form on submit.
	case onFocus

	/// Analytics key name.
	internal var analyticsName: String {
		switch self {
		case .onSubmit:
			return "on_submit_validation"
		case .onFocus:
			return "on_focus_validation"
		}
	}
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
	internal let validationBehavior: VGSCheckoutFormValidationBehaviour

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
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

  /// Validation manager.
	internal let formValidationHelper: VGSFormValidationHelper

	/// Autofocus manager.
	internal let autoFocusManager: VGSFieldAutofocusManager
  
	// MARK: - Initialization

	internal init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, validationBehavior: VGSCheckoutFormValidationBehaviour, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
    self.cardDetailsSectionView = VGSCardDetailsSectionView(checkoutConfigurationType: checkoutConfigurationType, uiTheme: uiTheme)
		self.formValidationHelper = formValidationHelper
		self.autoFocusManager = autoFocusManager

		buildForm()
	}

	// MARK: - Interface

	/// Builds form.
	internal func buildForm() {
		cardDetailsSectionView.translatesAutoresizingMaskIntoConstraints = false
		
		switch checkoutConfigurationType {
		case .custom(let configuration):
			setupCardForm(with: configuration)
		case .payoptAddCard(let configuration):
			setupCardForm(with: configuration)
		case .payoptTransfers(let configuration):
			setupCardForm(with: configuration)
		}

		for item in fieldViews {
			item.placeholderView.delegate = self
			item.delegate = self
		}
	}

	// MARK: - Helpers

	/// Setup card form with vault config.
	/// - Parameter vaultConfiguration: `VGSCheckoutCustomConfiguration` object, vault configuration.
	private func setupCardForm(with vaultConfiguration: VGSCheckoutCustomConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: vaultConfiguration, vgsCollect: vgsCollect, cardSectionView: cardDetailsSectionView)
	}

	/// Setup card form with payopt config.
	/// - Parameter configuration: `VGSCheckoutPaymentOrchestrationBasicConfiguration` object, payopt configuration.
	private func setupCardForm(with configuration: VGSCheckoutPaymentOrchestrationBasicConfiguration) {
		VGSCardDataFormConfigurationManager.setupCardForm(with: configuration, vgsCollect: vgsCollect, cardSectionView: cardDetailsSectionView)
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
          let cardState = textView.textFieldState as? CardState,
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
