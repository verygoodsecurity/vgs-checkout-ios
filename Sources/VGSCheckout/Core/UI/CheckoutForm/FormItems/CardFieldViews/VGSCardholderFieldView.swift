//
//  VGSCardholderFieldView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSCardholderFieldView: UIView, VGSTextFieldViewProtocol {
    
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
        errorLabel.text = "tyt mozhe buty vasha erorka"
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
