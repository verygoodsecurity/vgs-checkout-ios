//
//  VGSCardholderFieldView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

class VGSTextFieldViewUIConfigurationHandler {
    
    let theme: VGSCheckoutTextFieldThemeProtocol
    weak var view: VGSTextFieldViewProtocol?
    
    required init(view: VGSTextFieldViewProtocol, theme: VGSCheckoutTextFieldThemeProtocol) {
        self.view = view
        self.theme = theme
    }
    
    func applyTheme(_ theme: VGSCheckoutTextFieldViewUIAttributesProtocol) {
        /// textfield
        view?.textField.textColor = theme.textFieldTextColor
        view?.textField.font = theme.textFieldTextFont
        view?.textField.adjustsFontForContentSizeCategory = true
        /// placeholder
        view?.placeholderView.hintLabel.textColor = theme.textFieldHintTextColor
        view?.placeholderView.hintLabel.font = theme.textFieldHintTextFont
        /// errorlabel
    }
    
    func initial() {
        applyTheme(theme.adapt(theme: theme, for: .initial))
    }
    
    func valid() {
        applyTheme(theme.adapt(theme: theme, for: .valid))
    }
    
    func invalid() {
        applyTheme(theme.adapt(theme: theme, for: .invalid))
    }
    
    func focused() {
        applyTheme(theme.adapt(theme: theme, for: .focused))
    }
}

internal class VGSCardholderFieldView: UIView, VGSTextFieldViewProtocol, VGSTextFieldViewUIConfigurationProtocol {
    var delegate: VGSTextFieldViewDelegate?
    
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

    let errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()
    
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
        case .valid:
            uiConfigurationHandler?.valid()
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

        stackView.addArrangedSubview(errorLabel)
        errorLabel.text = String.checkout_emptyErrorText
        errorLabel.isHiddenInCheckoutStackView = false
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
