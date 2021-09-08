//
//  VGSTextFieldViewProtocol.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSTextFieldViewDelegate {
    
    // MARK: - Handle user ineraction with `VGSTextFieldViewProtocol`
    
    /// `VGSTextFieldViewProtocol` did become first responder.
    func vgsFieldViewDidBeginEditing(_ fieldView: VGSTextFieldViewProtocol)
    
    /// `VGSTextFieldViewProtocol` did resign first responder.
    func vgsFieldViewDidEndEditing(_ fieldView: VGSTextFieldViewProtocol)
    
    /// `VGSTextFieldViewProtocol` did resign first responder on Return button pressed.
    func vgsFieldViewDidEndEditingOnReturn(_ fieldView: VGSTextFieldViewProtocol)
    
    /// `VGSTextFieldViewProtocol` input changed.
    func vgsFieldViewdDidChange(_ fieldView: VGSTextFieldViewProtocol)
}


internal protocol VGSTextFieldViewProtocol: AnyObject, VGSTextFieldViewUIConfigurationProtocol {
	var placeholderView: VGSPlaceholderFieldView {get}
	var textField: VGSTextField {get}
	//var errorLabel: UILabel {get}
	var fieldType: VGSAddCardFormFieldType {get}
    
	var delegate: VGSTextFieldViewDelegate? {get set}

	var validationErrorView: VGSValidationErrorView {get}
}

internal protocol VGSTextFieldViewUIConfigurationProtocol {
    var uiConfigurationHandler: VGSTextFieldViewUIConfigurationHandler? {get set}    
    func updateUI(for uiState: VGSCheckoutFieldUIState)
}

extension VGSTextFieldViewUIConfigurationProtocol {
    func updateUI(for uiState: VGSCheckoutFieldUIState) {
        switch uiState {
        case .initial:
            uiConfigurationHandler?.initial()
        case .valid:
            uiConfigurationHandler?.valid()
        case .invalid:
            uiConfigurationHandler?.invalid()
        case .focused:
            uiConfigurationHandler?.focused()
        }
    }
}

public enum VGSCheckoutFieldUIState {
    case initial
	case focused
	case valid
	case invalid
}
