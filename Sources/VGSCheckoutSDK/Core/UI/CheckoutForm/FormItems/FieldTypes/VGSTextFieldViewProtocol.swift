//
//  VGSTextFieldViewProtocol.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSTextFieldViewDelegate: AnyObject {
    
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
  var textFieldState: State {get}
	var fieldType: VGSAddCardFormFieldType {get}
    
	var delegate: VGSTextFieldViewDelegate? {get set}

	var validationErrorView: VGSValidationErrorView {get}
}

internal extension VGSTextFieldViewProtocol {
  /// Return default textField state object.
  var textFieldState: State {
    return textField.state
  }
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
        case .filled:
            uiConfigurationHandler?.filled()
        case .invalid:
            uiConfigurationHandler?.invalid()
        case .focused:
            uiConfigurationHandler?.focused()
        }
    }
}

/// Defines field UI state.
public enum VGSCheckoutFieldUIState {

	/// Initial field.
	case initial

	/// Focused field.
	case focused

	/// Field has input text.
	case filled

	/// Field contains invalid data.
	case invalid
}
