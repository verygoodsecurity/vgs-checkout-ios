//
//  VGSBaseFieldView.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for base field view (has simple `VGSTextField`).
internal class VGSBaseFieldView: UIView, VGSTextFieldViewProtocol {
    weak var delegate: VGSTextFieldViewDelegate?
    
    var uiConfigurationHandler: VGSTextFieldViewUIConfigurationHandler?
    
    // MARK: - Attributes

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

    lazy var textField: VGSTextField = {
        let field = VGSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.cornerRadius = 0
        field.borderWidth = 0
        return field
    }()

    // MARK: - Initialization

	  /// no:doc
    override init(frame: CGRect) {
        super.init(frame: .zero)
        textField.delegate = self
        buildUI()
    }

		/// no:doc
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - VGSTextFieldDelegate

extension VGSBaseFieldView: VGSTextFieldDelegate {
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
