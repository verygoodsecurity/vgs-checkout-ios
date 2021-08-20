//
//  VGSCardDetailsFormView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form View with group of fields.
internal protocol VGSFormSectionViewProtocol: UIView {
	var errorLabel: UILabel {get}
    var uiTheme: VGSCheckoutThemeProtocol {get}
	func updateSectionBlocks(_ sectionBlocks: [VGSAddCardSectionBlock], isValid: Bool)
}

/// Holds UI for card details.
internal class VGSCardDetailsSectionView: UIView, VGSFormSectionViewProtocol {

	/// Defines field distribution.
	internal enum FieldsDistribution {
		case singleLineDateAndCVC
		case doubleLineDateAndCVC
		case singleLineAll
	}

	/// UI theme object.
  internal var uiTheme: VGSCheckoutThemeProtocol

	/// Form items.
	internal var fieldViews: [VGSTextFieldViewProtocol] = []

	/// Displays error messages for invalid card details.
  internal let errorLabel: UILabel

	/// Fields distribution.
	internal var fieldsDistribution: FieldsDistribution = .singleLineDateAndCVC

	/// Card number view.
	internal lazy var cardNumberFieldView: VGSCardNumberFieldView = {
        let componentView = VGSCardNumberFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .cardNumber
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_hint")
        return componentView
	}()

	/// Exp date view.
	internal lazy var expDateFieldView: VGSExpirationDateFieldView = {
        
        let componentView = VGSExpirationDateFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .expirationDate
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")
        return componentView
	}()

	/// CVC view.
	internal lazy var cvcFieldView: VGSCVCFieldView = {
		let componentView = VGSCVCFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .cvc
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code_hint")
		return componentView
	}()

	/// Card holder view.
	internal let cardHolderDetailsView: VGSCardHolderDetailsView

	/// Container view for header to add insets.
	internal lazy var headerContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

		return view
	}()

	/// Header view.
	internal lazy var headerView: VGSCheckoutHeaderView = {
		let headerView = VGSCheckoutHeaderView(frame: .zero)
		headerView.translatesAutoresizingMaskIntoConstraints = false

		let title = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_form_card_details_title")
		let model = VGSCheckoutHeaderViewModel(text: title)

		headerView.configure(with: model, uiTheme: uiTheme)

		return headerView
	}()

	/// Root stack view.
	internal lazy var rootStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical

		stackView.spacing = 8

		return stackView
	}()

	/// Vertical stack view for all fields.
	internal lazy var verticalStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical
		stackView.hasBorderView = false
		stackView.borderViewCornerRadius = 4
		stackView.spacing = 1
//        stackView.separatorColor = uiTheme.textFieldBorderColor

		return stackView
	}()

	/// Horizontal stack view for exp date and cvc.
	internal lazy var horizonalStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
        stackView.hasBorderView = false
		stackView.spacing = 20

		return stackView
	}()

	/// Payment instrument.
	fileprivate let paymentInstrument: VGSPaymentInstrument

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter paymentInstrument: `VGSPaymentInstrument` object, payment instrument.
  init(paymentInstrument: VGSPaymentInstrument, uiTheme: VGSCheckoutThemeProtocol) {
		self.paymentInstrument = paymentInstrument
    self.uiTheme = uiTheme
    self.errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel(with: uiTheme)
		self.cardHolderDetailsView = VGSCardHolderDetailsView(paymentInstrument: paymentInstrument)
    
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Interface
  
  /// Update Array of form blocks with validation state.
  internal func updateSectionBlocks(_ sectionBlocks: [VGSAddCardSectionBlock], isValid: Bool) {
    sectionBlocks.forEach { sectionBlock in
      updateSectionBlock(sectionBlock, isValid: isValid)
    }
  }

  /// Update Form block items UI with validation state.
	internal func updateSectionBlock(_ block: VGSAddCardSectionBlock, isValid: Bool) {
//		switch block {
//		case .cardHolder:
//			if isValid {
//        cardHolderDetailsView.cardHolderNameStackView.separatorColor = uiTheme.textFieldBorderColor
//			} else {
//				cardHolderDetailsView.cardHolderNameStackView.separatorColor = uiTheme.textFieldBorderErrorColor
//			}
//		case .cardDetails:
//			if isValid {
//				verticalStackView.separatorColor = uiTheme.textFieldBorderColor
//				horizonalStackView.separatorColor = uiTheme.textFieldBorderColor
//			} else {
//				verticalStackView.separatorColor = uiTheme.textFieldBorderErrorColor
//				horizonalStackView.separatorColor = uiTheme.textFieldBorderErrorColor
//			}
//		case .addressInfo:
//			break
//		}
	}
  
  /// TODO: Add option to set UI for ProcessingState ???

	/// Disable input view for processing state.
	internal func updateUIForProcessingState() {
//		// Update grid view.
//		if #available(iOS 13, *) {
//			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.systemGray
//			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
//			verticalStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
//		} else {
//			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.gray
//			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.gray.cgColor
//			verticalStackView.borderView.layer.borderColor = UIColor.gray.cgColor
//		}

		// Update form fields.
		fieldViews.forEach { fieldView in
			if #available(iOS 13.0, *) {
				fieldView.placeholderView.backgroundColor = .systemGroupedBackground
				fieldView.textField.textColor = UIColor.placeholderText
				fieldView.placeholderView.hintComponentView.label.textColor = UIColor.placeholderText
			} else {
				fieldView.placeholderView.backgroundColor = .white
				fieldView.textField.textColor = .gray
				fieldView.placeholderView.hintComponentView.label.textColor = .gray
			}
		}
	}

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(rootStackView)
		rootStackView.checkout_constraintViewToSuperviewEdges()

		headerContainerView.addContentView(headerView)
		rootStackView.addArrangedSubview(headerContainerView)

		switch paymentInstrument {
		case .vault(let configuration):
			switch configuration.cardHolderFieldOptions.fieldVisibility {
			case .visible:
				cardHolderDetailsView.translatesAutoresizingMaskIntoConstraints = false
				rootStackView.addArrangedSubview(cardHolderDetailsView)
			default:
				break
			}
		case .multiplexing:
			cardHolderDetailsView.translatesAutoresizingMaskIntoConstraints = false
			rootStackView.addArrangedSubview(cardHolderDetailsView)
		}

		rootStackView.addArrangedSubview(verticalStackView)

    cardNumberFieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    cardNumberFieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		verticalStackView.addArrangedSubview(cardNumberFieldView)

		switch fieldsDistribution {
		case .singleLineDateAndCVC:
			setupDateAndCVC(in: true)
		case .doubleLineDateAndCVC:
			setupDateAndCVC(in: false)
		case .singleLineAll:
			setupAllInSingleLine()
		}

		rootStackView.addArrangedSubview(errorLabel)
		errorLabel.isHiddenInCheckoutStackView = true

		// Gather all form items.
		fieldViews = cardHolderDetailsView.fildViews + [
			cardNumberFieldView,
			expDateFieldView,
			cvcFieldView,
		]

    /// Set UI Theme
    for item in fieldViews {
			item.updateStyle(with: uiTheme)
    }
    
		fieldViews.first?.textField.becomeFirstResponder()
	}

	private func setupDateAndCVC(in singleLine: Bool) {
		if singleLine {
			horizonalStackView.axis = .horizontal
		} else {
			horizonalStackView.axis = .vertical
		}

		expDateFieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateFieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		cvcFieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcFieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		horizonalStackView.addArrangedSubview(expDateFieldView)
		horizonalStackView.addArrangedSubview(cvcFieldView)

		verticalStackView.addArrangedSubview(horizonalStackView)
	}

	private func setupAllInSingleLine() {
		expDateFieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateFieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		cvcFieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcFieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		verticalStackView.axis = .horizontal
		verticalStackView.addArrangedSubview(expDateFieldView)
		verticalStackView.addArrangedSubview(cvcFieldView)
	}
}
