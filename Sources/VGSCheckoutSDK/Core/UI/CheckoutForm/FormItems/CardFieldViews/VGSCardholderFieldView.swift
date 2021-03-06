//
//  VGSCardholderFieldView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSTextFieldViewUIConfigurationHandler: VGSCheckoutTextFieldThemeAdapterProtocol {
    
		internal let theme: VGSCheckoutTextFieldThemeProtocol
		internal weak var view: VGSTextFieldViewProtocol?

		internal required init(view: VGSTextFieldViewProtocol, theme: VGSCheckoutTextFieldThemeProtocol) {
        self.view = view
        self.theme = theme
    }
    
		internal func applyTheme(_ theme: VGSCheckoutTextFieldViewUIAttributesProtocol) {

			  // Set text field view background color - text field and placeholder view.
			  view?.placeholderView.backgroundColor = theme.textFieldBackgroundColor
				view?.placeholderView.layer.borderColor = theme.textFieldBorderColor.cgColor

			  // TextField UI.
        view?.textField.textColor = theme.textFieldTextColor
        view?.textField.font = theme.textFieldTextFont
        view?.textField.adjustsFontForContentSizeCategory = true

			  // Placeholder UI.
        view?.placeholderView.hintLabel.textColor = theme.textFieldHintTextColor
        view?.placeholderView.hintLabel.font = theme.textFieldHintTextFont

			  // Error label UI.
				view?.validationErrorView.errorLabel.textColor = theme.textFieldErrorLabelColor
				view?.validationErrorView.errorLabel.font = theme.textFieldErrorLabelFont
    }
    
		internal func initial() {
        let stateTheme = self.adapt(theme: theme, for: .initial)
        applyTheme(stateTheme)
				view?.placeholderView.hintComponentView.accessory = .none
    }
    
		internal func filled() {
        let stateTheme = self.adapt(theme: theme, for: .filled)
        applyTheme(stateTheme)
        view?.placeholderView.hintComponentView.accessory = .none
    }
    
		internal func invalid() {
        let stateTheme = self.adapt(theme: theme, for: .invalid)
        applyTheme(stateTheme)
				view?.placeholderView.hintComponentView.accessory = .invalid
    }
    
		internal func focused() {
        let stateTheme = self.adapt(theme: theme, for: .focused)
        applyTheme(stateTheme)
				view?.placeholderView.hintComponentView.accessory = .none
    }
}

internal class VGSCardholderFieldView: UIView, VGSTextFieldViewProtocol, VGSTextFieldViewUIConfigurationProtocol {
    weak var delegate: VGSTextFieldViewDelegate?
    
    // MARK: - Attributes
    internal var fieldType: VGSAddCardFormFieldType = .cardholderName
    
    internal var placeholder: String? {
        set {
            textField.placeholder = newValue
        }
        get {
            return textField.placeholder
        }
    }
    
    internal var subtitle: String? {
        set {
            placeholderView.hintComponentView.label.text = newValue
        }
        get {
            return placeholderView.hintComponentView.label.text
        }
    }
    
    var uiConfigurationHandler: VGSTextFieldViewUIConfigurationHandler?

    // MARK: - Views

    let placeholderView = VGSPlaceholderFieldView(frame: .zero)

		/// Validation error view.
		let validationErrorView: VGSValidationErrorView = VGSAddCardFormViewBuilder.buildErrorView()
    
    /// Stack view.
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    var textField: VGSTextField {
        return cardHolderTextField
    }
    
    private lazy var cardHolderTextField: VGSTextField = {
        let field = VGSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.cornerRadius = 0
        field.borderWidth = 0
        return field
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        textField.delegate = self
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI State Handler
    
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

    // MARK: - Helpers

    private func buildUI() {
        addSubview(stackView)
        stackView.checkout_constraintViewToSuperviewEdges()

        stackView.addArrangedSubview(placeholderView)
        buildPlaceholderUI()

        stackView.addArrangedSubview(validationErrorView)
    }
    
    private func buildPlaceholderUI() {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.stackView.addArrangedSubview(textField)
        placeholderView.layer.borderColor = UIColor.lightGray.cgColor
        placeholderView.layer.borderWidth = 1
        placeholderView.layer.cornerRadius = 6
    }
}

extension VGSCardholderFieldView: VGSTextFieldDelegate {
    func vgsTextFieldDidBeginEditing(_ textField: VGSTextField) {
        delegate?.vgsFieldViewDidBeginEditing(self)
    }
    
    func vgsTextFieldDidChange(_ textField: VGSTextField) {
        delegate?.vgsFieldViewdDidChange(self)
    }
    
    func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
        delegate?.vgsFieldViewDidEndEditing(self)
    }
    
    func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
        delegate?.vgsFieldViewDidEndEditingOnReturn(self)
    }
}
