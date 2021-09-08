//
//  VGSAddressLineFieldView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for address line form item.
internal class VGSErrorFieldView: UIView, VGSTextFieldViewProtocol {
    var delegate: VGSTextFieldViewDelegate?
    
    var uiConfigurationHandler: VGSTextFieldViewUIConfigurationHandler?
    
    // MARK: - Attributes

    /// TODO: remove hardcoded value
    internal var fieldType: VGSAddCardFormFieldType = .addressLine1
    
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

    // MARK: - Views
    let placeholderView = VGSPlaceholderFieldView(frame: .zero)

    let errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()
    
    /// Stack view.
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    lazy var textField: VGSTextField = {
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

    // MARK: - Helpers

    private func buildUI() {
        addSubview(stackView)
        stackView.checkout_constraintViewToSuperviewEdges()

        stackView.addArrangedSubview(placeholderView)
        buildPlaceholderUI()

        stackView.addArrangedSubview(errorLabel)
        errorLabel.text = String.checkoutEmptyErrorText
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

extension VGSErrorFieldView: VGSTextFieldDelegate {
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
