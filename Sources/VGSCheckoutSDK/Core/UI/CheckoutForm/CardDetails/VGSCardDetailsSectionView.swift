//
//  VGSCardDetailsFormView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for card details.
internal class VGSCardDetailsSectionView: UIView {

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


	/// Fields distribution.
	internal var fieldsDistribution: FieldsDistribution = .singleLineDateAndCVC

	/// Card number view.
	internal lazy var cardNumberFieldView: VGSCardNumberFieldView = {
				let componentView = VGSCardNumberFieldView(frame: .zero)
				componentView.translatesAutoresizingMaskIntoConstraints = false
				componentView.fieldType = .cardNumber
				componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
				componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_subtitle")
				componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_hint")
				return componentView
	}()

	/// Exp date view.
	internal lazy var expDateFieldView: VGSExpirationDateFieldView = {

				let componentView = VGSExpirationDateFieldView(frame: .zero)
				componentView.translatesAutoresizingMaskIntoConstraints = false
				componentView.fieldType = .expirationDate
				componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
				componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_subtitle")
				componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_hint")
				return componentView
	}()

	/// CVC view.
	internal lazy var cvcFieldView: VGSCVCFieldView = {
		let componentView = VGSCVCFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
				componentView.fieldType = .cvc
				componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
				componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code_subtitle")
				componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code")
		return componentView
	}()

		/// Card holder view.
		internal lazy var cardHolderFieldView: VGSCardholderFieldView = {
				let componentView = VGSCardholderFieldView(frame: .zero)
				componentView.translatesAutoresizingMaskIntoConstraints = false
				componentView.fieldType = .cardholderName
				componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
				componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_subtitle")
				componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_hint")
				return componentView
		}()

	/// Container view for header to add insets.
	internal lazy var headerContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

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
	private lazy var rootStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical

		stackView.spacing = 8

		return stackView
	}()

		/// Container view
		private lazy var containerView: UIView = {
				let view = UIView(frame: .zero)
				view.translatesAutoresizingMaskIntoConstraints = false
				view.backgroundColor = .clear
				return view
		}()

	/// Vertical stack view for all fields.
	internal lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical

		return stackView
	}()

	/// Horizontal stack view for exp date and cvc.
	internal lazy var horizonalStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		stackView.spacing = 20

		return stackView
	}()

	/// Payment instrument.
	fileprivate let checkoutConfigurationType: VGSCheckoutConfigurationType

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter checkoutConfigurationType: `VGScheckoutConfigurationType` object, payment instrument.
	init(checkoutConfigurationType: VGSCheckoutConfigurationType, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.uiTheme = uiTheme
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Interface

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {

		backgroundColor = uiTheme.checkoutSectionViewBackgroundColor
		layer.cornerRadius = 8

		addSubview(containerView)
		containerView.checkout_defaultSectionViewConstraints()

		containerView.addSubview(rootStackView)
		rootStackView.checkout_constraintViewToSuperviewEdges()

		headerContainerView.addContentView(headerView)
		rootStackView.addArrangedSubview(headerContainerView)

		switch checkoutConfigurationType {
		case .custom(let configuration):
			switch configuration.cardHolderFieldOptions.fieldVisibility {
			case .visible:
				verticalStackView.addArrangedSubview(cardHolderFieldView)
			default:
				break
			}
		case .payoptAddCard, .payoptTransfers:
			verticalStackView.addArrangedSubview(cardHolderFieldView)
		}

		rootStackView.addArrangedSubview(verticalStackView)

		cardHolderFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings

		cardNumberFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings
		verticalStackView.addArrangedSubview(cardNumberFieldView)

		switch fieldsDistribution {
		case .singleLineDateAndCVC:
			setupDateAndCVC(in: true)
		case .doubleLineDateAndCVC:
			setupDateAndCVC(in: false)
		case .singleLineAll:
			setupAllInSingleLine()
		}

		// Gather all form items.
		fieldViews = [
			cardHolderFieldView,
			cardNumberFieldView,
			expDateFieldView,
			cvcFieldView
		]

		/// Set UI Theme
		fieldViews.forEach { item in
			item.updateUI(for: .initial)
			item.textField.padding = VGSUIConstants.FormUI.textFieldPaddings
		}

		fieldViews.first?.textField.becomeFirstResponder()

		expDateFieldView.validationErrorView.isLastRow = true
		cvcFieldView.validationErrorView.isLastRow = true
	}

	private func setupDateAndCVC(in singleLine: Bool) {
		if singleLine {
			horizonalStackView.axis = .horizontal
		} else {
			horizonalStackView.axis = .vertical
		}

		expDateFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings

		cvcFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings

		horizonalStackView.addArrangedSubview(expDateFieldView)
		horizonalStackView.addArrangedSubview(cvcFieldView)

		verticalStackView.addArrangedSubview(horizonalStackView)
	}

	private func setupAllInSingleLine() {
		expDateFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings

		cvcFieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings

		verticalStackView.axis = .horizontal
		verticalStackView.addArrangedSubview(expDateFieldView)
		verticalStackView.addArrangedSubview(cvcFieldView)
	}
}
