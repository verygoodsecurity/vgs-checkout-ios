//
//  VGSCheckoutComponent.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal protocol VGSComponentProtocol {
	var view: UIView {get}
}

public class VGSCheckoutComponent: NSObject {

//	internal var config: VGSCheckoutConfiguration?

	enum FormState {
		case invalid
		case valid
		case processing
	}

	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				payButton.status = .disabled
			case .valid:
				payButton.status = .enabled
			case .processing:
				payButton.status = .processing
			}
		}
	}

	// MARK: - View

	internal lazy var backgroundStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .vertical
		stackView.distribution = .fill

		stackView.layer.cornerRadius = 4
		stackView.layer.borderColor = UIColor(hexString: "#C8D0DB").cgColor
		stackView.layer.borderWidth = 1

		stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		return stackView
	}()

	internal lazy var payButton: VGSSubmitButton = {
		let button = VGSSubmitButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

		return button
	}()

	internal lazy var payButtonContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.addContentView(payButton)
		view.paddings = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		return view
	}()

	internal lazy var cardCheckoutView: VGSCheckoutCardFormView = {
		let view = VGSCheckoutCardFormView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Form view.
	lazy var formView: VGSFormView = {
		let view = VGSFormView()

		return view
	}()

	internal lazy var formController: VGSFormViewController = {
		let viewController = VGSFormViewController(formView: formView)
		viewController.formView.stackView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
		viewController.formView.stackView.isLayoutMarginsRelativeArrangement = true

		viewController.formView.addFormItemView(backgroundStackView)

		backgroundStackView.addArrangedSubview(cardCheckoutView)
		backgroundStackView.addArrangedSubview(payButtonContainerView)

		//viewController.formView.addFormItemView(payButtonContainerView)

		let view = UIView()
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false

//		viewController.formView.stackView.layer.borderWidth = 1
//		viewController.formView.stackView.layer.cornerRadius = 4

		viewController.formView.addFormItemView(view)

		return viewController
	}()

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	// MARK: - Helpers

	internal func buildForm() {
		setupElementsConfiguration()
		payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
	}

	@objc fileprivate func payDidTap() {
		payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.payButton.status = .success
		}
	}

	var textFiedComponents: [VGSTextFieldFormComponentProtocol] {
		return [cardCheckoutView.cardNumberComponentView,
						cardCheckoutView.expDateComponentView,
						cardCheckoutView.cvcDateComponentView]
	}

	public func presentCheckout(from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		formController.modalPresentationStyle = .overFullScreen
		viewController.present(formController, animated: animated, completion: completion)
	}
}
