//
//  VGSBaseCardViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

#if canImport(CardIO)
		import CardIO
#endif

enum CardScanners {
	case none
	case cardIO(_ configuration: AnyObject)
}

struct CardScanOptions {
	var cardScanner: CardScanners = .none
}

/// Interface to notify about changes/actions in `VGSCheckoutBaseCardViewController`.
internal protocol VGSCheckoutBaseCardViewControllerDelegate: AnyObject {
	func submitButtonDidTap(in formState: VGSBaseCardViewController.FormState, viewController: VGSBaseCardViewController)
	func closeButtonDidTap(in viewController: VGSBaseCardViewController)
}

/// Base view controller that holds UI for entering card data.
internal class VGSBaseCardViewController: VGSFormViewController {

	/// An objec that acts as a view controller delegate.
	internal weak var delegate: VGSCheckoutBaseCardViewControllerDelegate?

	/// Defines form state.
	internal enum FormState {

		/// Form has invalid data.
		case invalid

		/// Form has valid data and ready for precessing.
		case valid

		/// Form is in processing state.
		case processing
	}

	/// Holds scan view.
	fileprivate lazy var scanView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.heightAnchor.constraint(equalToConstant: 500).isActive = true
		view.backgroundColor = .clear

		#if canImport(CardIO)
			let cardIOView = CardIOView(frame: .zero)
			view.addSubview(cardIOView)
			cardIOView.translatesAutoresizingMaskIntoConstraints = false
			cardIOView.checkout_constraintViewToSuperviewEdges()
			cardIOView.delegate = self
		  print("Add CARD.IO!")
		#else
		  print("Card IO not found!")
		
		#endif

		return view
	}()

	// MARK: - Vars

	/// Manager for card data logic.
	internal let cardDataSectionViewModel: VGSCardDataSectionViewModel

	/// Manager for billing address logic.
	internal let addressDataSectionViewModel: VGSAddressDataSectionViewModel

	/// Main view.
	internal let addCardSectionFormView: VGSSaveCardFormView

	/// Checkout configuration type.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// `VGSCollect` object.
	fileprivate let vgsCollect: VGSCollect

	/// UI Theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	/// Close bar button item.
	fileprivate var closeBarButtomItem: UIBarButtonItem?

	fileprivate lazy var scanBarButtonItem: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "Scan", style: .done, target: self, action: #selector(scanCard))

		return item
	}()

	/// Validation bevaior, default is `.onSubmit`.
	fileprivate var validationBehavior: VGSCheckoutFormValidationBehaviour

	/// Holds the entire form state.
	var formState = FormState.invalid {
		didSet {
			switch formState {
			case .invalid:
				updateCloseBarButtonItem(true)
				addCardSectionFormView.submitButton.status = .enabled

			case .valid:
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.isUserInteractionEnabled = true
				updateCloseBarButtonItem(true)
				addCardSectionFormView.submitButton.status = .enabled
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				updateCloseBarButtonItem(false)
				addCardSectionFormView.submitButton.status = .processing
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha =  VGSUIConstants.FormUI.formProcessingAlpha
			}
			delegate?.submitButtonDidTap(in: formState, viewController: self)
		}
	}

	// MARK: - Initializer

	internal init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme
		self.validationBehavior = checkoutConfigurationType.formValidationBehaviour

		let formValidationHelper = VGSFormValidationHelper(fieldViews: [], validationBehaviour: self.validationBehavior)
		let autoFocusManager = VGSFieldAutofocusManager(fieldViewsManager: VGSFieldViewsManager(fieldViews: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

		switch checkoutConfigurationType {
		case .custom(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "custom"])
		case .payoptAddCard(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "payopt", "configType": "addCard"])
		case .payoptTransfers(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "payopt", "configType": "transfers"])
		}

		self.addCardSectionFormView = VGSSaveCardFormView(cardDetailsView: cardDataSectionViewModel.cardDetailsSectionView, billingAddressView: addressDataSectionViewModel.billingAddressFormView, viewLayoutStyle: .fullScreen, uiTheme: uiTheme)

		formValidationHelper.fieldViewsManager.appendFieldViews(self.cardDataSectionViewModel.cardDetailsSectionView.fieldViews)

		if checkoutConfigurationType.isAddressVisible {
			formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
			addressDataSectionViewModel.updateInitialPostalCodeUI()
		}

		super.init(formView: addCardSectionFormView)
	}

	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var isScanEnabled = false {
		didSet {
			if isScanEnabled {
				if formView.stackView.arrangedSubviews[0] !== scanView {
					formView.stackView.insertArrangedSubview(scanView, at: 0)
				}
				scanView.isHidden = false
				scanView.subviews.first?.isHidden = false
			} else {
				scanView.isHidden = true
				scanView.subviews.first?.isHidden = true
			}
		}
	}

	@objc func scanCard() {
		isScanEnabled.toggle()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDelegates()
		setupMainUI()
	}

	// MARK: - Helpers

	private func setupDelegates() {
		addCardSectionFormView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
		cardDataSectionViewModel.delegate = self
		addressDataSectionViewModel.delegate = self
	}

	private func setupMainUI() {
		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))
		navigationItem.leftBarButtonItem = closeBarButtomItem
		navigationItem.rightBarButtonItem = scanBarButtonItem
	}

	// MARK: - Helpers

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .cancel)
		delegate?.closeButtonDidTap(in: self)
	}

	/// Handles tap on the submit button.
	@objc fileprivate func submitButtonDidTap() {
				let invalidFieldNames = cardDataSectionViewModel.formValidationHelper.analyticsInvalidFieldNames
		// Explicitly set payload and custom headers to analytics event content since we track beforeSubmit regardless sending API request.
		vgsCollect.trackBeforeSubmit(with: invalidFieldNames, configurationAnalytics: checkoutConfigurationType.configuration)
				switch formState {
				case .valid:
						formState = .processing
				case .invalid:
						showFormValidationErrors()
				default:
						return
				}
	}

	/// Displays all form validation errors.
	private func showFormValidationErrors() {
		cardDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
		addressDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
		if let firstInvalidField = cardDataSectionViewModel.formValidationHelper.fieldViewsWithValidationErrors.first {
			let visibleRect = firstInvalidField.placeholderView.convert(firstInvalidField.placeholderView.frame, to: addCardSectionFormView.scrollView)
			addCardSectionFormView.scrollView.scrollRectToVisible(visibleRect, animated: true)
		}
	}

	/// Updates `.isEnabled` state for left bar button item if checkout is dislayed in viewController.
	/// - Parameter isEnabled: `Bool` object, indicates `isEbabled` state for close left bar button item.
	private func updateCloseBarButtonItem(_ isEnabled: Bool) {
		navigationItem.leftBarButtonItem?.isEnabled = isEnabled
	}
}

// MARK: - VGSFormSectionPresenterDelegate

extension VGSBaseCardViewController: VGSFormSectionPresenterDelegate {
	func stateDidChange(_ state: VGSFormSectionState) {
		switch state {
		case .invalid:
			formState = .invalid
		case .valid:
			formState = .valid
		}
		updateSubmitButtonUI(with: state)
	}

	internal func updateSubmitButtonUI(with formState: VGSFormSectionState) {
		switch validationBehavior {
		case .onSubmit:
			break
		case .onFocus:
			break
		}
	}
}

#if canImport(CardIO)
extension VGSBaseCardViewController: CardIOViewDelegate {
	func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
		if cardInfo != nil && cardInfo.cardNumber != nil {
 cardDataSectionViewModel.cardDetailsSectionView.cardNumberFieldView.textField.setText(cardInfo.cardNumber)
		}

		if cardInfo != nil {
			let expiryDateData = VGSCardIOExpirationDate(month: cardInfo.expiryMonth, year: cardInfo.expiryYear)


			// Should we autofill invalid date?
			if let defaultExpirationDate = VGSCardIODataMapUtils.mapCardExpirationData(expiryDateData, scannedDataType: .expirationDate) {
				cardDataSectionViewModel.cardDetailsSectionView.expDateFieldView.textField.setText(defaultExpirationDate)
			}
		}

		// Hide view on finish scan.
		scanView.subviews.first?.isHidden = true
		isScanEnabled = false
	}
}
#endif

/// Holds scanned expiration date data (CardIO).
/// CardIO sends to delegate exp date in `UInt` format, CardIO text: `03/25` => output is `3` for month, `2025` for year.
/// Year is always in long format (`2025`, `YYYY`).
internal struct VGSCardIOExpirationDate {
	/// Scanned month.
	internal let month: UInt

	/// Scanned year.
	internal let year: UInt
}

/// Holds mapping utils for scanned card data.
internal final class VGSCardIODataMapUtils {

	// MARK: - Constants

	/// Valid months range.
	private static let monthsRange = 1...12

	// MARK: - Interface

	/// Maps scanned expiration data to expected format.
	/// - Parameters:
	///   - data: `VGSCardIOExpirationDate` object, scanned expiry date data.
	///   - scannedDataType: `CradIODataType` object, CardIO data type.
	/// - Returns: `String?`, formatted string or `nil`.
	internal static func mapCardExpirationData(_ data: VGSCardIOExpirationDate, scannedDataType: CradIODataType) -> String? {
		switch scannedDataType {
		case .cardNumber, .cvc:
			return nil
		case  .expirationDate:
			return mapDefaultExpirationDate(data.month, scannedExpYear: data.year)
		case .expirationDateLong:
			return mapLongExpirationDate(data.month, scannedExpYear: data.year)
		case .expirationMonth:
			return mapMonth(data.month)
		case .expirationYear:
			return mapYear(data.year)
		case .expirationYearLong:
			return mapYearLong(data.year)
		case .expirationDateShortYearThenMonth:
			return mapExpirationDateWithShortYearFirst(data.month, scannedExpYear: data.year)
		case .expirationDateLongYearThenMonth:
			return mapLongExpirationDateWithLongYearFirst(data.month, scannedExpYear: data.year)
		}
	}

	// MARK: - Helpers

	/// Maps scanned exp month and year to valid format (MM/YY).
	/// - Parameters:
	///   - scannedExpMonth: `UInt` object, scanned expiry month.
	///   - scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, composed text or nil if scanned info is invalid.
	private static func mapDefaultExpirationDate(_ scannedExpMonth: UInt, scannedExpYear: UInt) -> String? {
		guard let month = mapMonth(scannedExpMonth), let year = mapYear(scannedExpYear) else {
			return nil
		}

		return "\(month)\(year)"
	}

	/// Maps scanned exp month and year to valid format starting with  year  (YY/MM).
	/// - Parameters:
	///   - scannedExpMonth: `UInt` object, scanned expiry month.
	///   - scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, composed text or nil if scanned info is invalid.
	private static func mapExpirationDateWithShortYearFirst(_ scannedExpMonth: UInt, scannedExpYear: UInt) -> String? {
		guard let month = mapMonth(scannedExpMonth), let year = mapYear(scannedExpYear) else {
			return nil
		}

		return "\(year)\(month)"
	}

	/// Maps scanned exp month and year to long expiration date format (MM/YYYY).
	/// - Parameters:
	///   - scannedExpMonth: `UInt` object, scanned expiry month.
	///   - scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, composed text or nil if scanned info is invalid.
	private static func mapLongExpirationDate(_ scannedExpMonth: UInt, scannedExpYear: UInt) -> String? {
		guard let month = mapMonth(scannedExpMonth), let longYear = mapYearLong(scannedExpYear) else {
			return nil
		}

		return "\(month)\(longYear)"
	}

	/// Maps scanned exp month and year to long expiration date format starting with  year (YYYY/MM).
	/// - Parameters:
	///   - scannedExpMonth: `UInt` object, scanned expiry month.
	///   - scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, composed text or nil if scanned info is invalid.
	private static func mapLongExpirationDateWithLongYearFirst(_ scannedExpMonth: UInt, scannedExpYear: UInt) -> String? {
		guard let month = mapMonth(scannedExpMonth), let longYear = mapYearLong(scannedExpYear) else {
			return nil
		}

		return "\(longYear)\(month)"
	}

	/// Maps scanned expiry month to short format (MM) string.
	/// - Parameter scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, year text or nil if scanned info is invalid.
	private static func mapMonth(_ scannedExpMonth: UInt) -> String? {
		guard let month = monthInt(from: scannedExpMonth) else {return nil}

		let formattedMonthString = formatMonthString(from: month)
		return formattedMonthString
	}

	/// Maps scanned expiry year to short format (YY) string.
	/// - Parameter scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, year text or nil if scanned info is invalid.
	private static func mapYear(_ scannedExpYear: UInt) -> String? {
		guard let year = yearInt(from: scannedExpYear) else {return nil}

		// CardIO holds year in long format (2025), convert to short (25) format manually.
		return shortYearString(from: year)
	}

	/// Maps scanned expiry year to long format (YYYY) string.
	/// - Parameter scannedExpYear: `UInt` object, scanned expiry year.
	/// - Returns: `String?`, year text or nil if scanned info is invalid.
	private static func mapYearLong(_ scannedExpYear: UInt) -> String? {
		guard let year = yearInt(from: scannedExpYear) else {return nil}

		return "\(year)"
	}

	/// Converts year to long format string.
	/// - Parameter longYear: `UInt` object, should be short year.
	/// - Returns: `String` with long year format.
	private static func shortYearString(from longYear: UInt) -> String {
		return String("\(longYear)".suffix(2))
	}

	/// Checks if month (UInt) is valid.
	/// - Parameter month: `UInt` object, month to verify.
	/// - Returns: `Bool` object, `true` if is valid.
	private static func isMonthValid(_ month: UInt) -> Bool {
		return monthsRange ~= Int(month)
	}

	/// Checks if year (Int) is valid.
	/// - Parameter year: `UInt` object, year to verify.
	/// - Returns: `Bool` object, `true` if is valid.
	private static func isYearValid(_ year: UInt) -> Bool {
		// CardIO returns year in long format: `2025`.
		return year >= Calendar.currentYear
	}

	/// Provides month Int.
	/// - Parameter month: `UInt` object, month from CardIO.
	/// - Returns: `UInt?`, valid month or `nil`.
	private static func monthInt(from month: UInt) -> UInt? {
		guard isMonthValid(month) else {
			return nil
		}

		return month
	}

	/// Provides year Int.
	/// - Parameter year: `UInt` object, year from CardIO.
	/// - Returns: `UInt?`, valid year or `nil`.
	private static func yearInt(from year: UInt) -> UInt? {
		guard isYearValid(year) else {
			return nil
		}

		return year
	}

	/// Formats month int.
	/// - Parameter monthInt: `UInt` object, should be month.
	/// - Returns: `String` object, formatted month.
	private static func formatMonthString(from monthInt: UInt) -> String {
		// Add `0` for month less than 10.
		let monthString = monthInt < 10 ? "0\(monthInt)" : "\(monthInt)"
		return monthString
	}
}

/// Supported scan data fields by Card.io
@objc
internal enum CradIODataType: Int {

		/// Credit Card Number. 16 digits string.
		case cardNumber

		/// Credit Card Expiration Date. String in format "01/21".
		case expirationDate

		/// Credit Card Expiration Month. String in format "01".
		case expirationMonth

		/// Credit Card Expiration Year. String in format "21".
		case expirationYear

		/// Credit Card CVC code. 3-4 digits string in format "123".
		case cvc

		/// Credit Card Expiration Date. String in format "01/2021".
		case expirationDateLong

		/// Credit Card Expiration Year. String in format "2021".
		case expirationYearLong

		/// Credit Card Expiration Date. String in format "21/01".
		case expirationDateShortYearThenMonth

		/// Credit Card Expiration Date. String in format "2021/01".
		case expirationDateLongYearThenMonth
}
