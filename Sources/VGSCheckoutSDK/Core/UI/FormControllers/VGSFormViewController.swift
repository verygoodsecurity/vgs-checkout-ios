//
//  VGSFormViewController.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// `UIViewController` subclass to display forms.
internal class VGSFormViewController: UIViewController {

	// MARK: - Vars

	/// Form view.
	internal let formView: VGSFormView

	/// Bottom constraint to manage view position on keyboard show/hide notifications.
	private var formKeyboardGuideBottomConstraint: NSLayoutConstraint?

	private let tapGestureRecognizer = UITapGestureRecognizer()

	// MARK: - Initialization

	/// Intialization.
	/// - Parameter formView: `UIView` object, form view.
	init(formView: VGSFormView) {
		self.formView = formView
		super.init(nibName: nil, bundle: nil)
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		addListeners()
		formView.addGestureRecognizer(tapGestureRecognizer)
		tapGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
		tapGestureRecognizer.cancelsTouchesInView = false
	}

	// MARK: - Helpers

	/// Setup basic UI and laout.
	internal func setupUI() {
		view.addSubview(formView)
		formView.translatesAutoresizingMaskIntoConstraints = false

		if #available(iOS 13.0, *) {
			view.backgroundColor = .systemBackground
		} else {
			view.backgroundColor = .white
		}

		var formConstraints = [NSLayoutConstraint?]()
		if #available(iOS 11.0, *) {
			formKeyboardGuideBottomConstraint = formView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			formConstraints = [
				formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				formKeyboardGuideBottomConstraint,
				formView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				formView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
			]
		} else {
			formKeyboardGuideBottomConstraint = formView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			formConstraints = [
				formView.topAnchor.constraint(equalTo: view.topAnchor),
				formKeyboardGuideBottomConstraint,
				formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				formView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		}

		formKeyboardGuideBottomConstraint?.priority = .defaultHigh
		NSLayoutConstraint.activate(formConstraints.compactMap { $0 })
	}

	/// Add listeners for keyboard notifcations.
	internal func addListeners() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
																	 selector: #selector(handleKeyboardFrameUpdate(_:)),
																	 name: UIResponder.keyboardWillChangeFrameNotification,
																	 object: nil)
	}

	/// Handle keyboard notification.
	@objc private func handleKeyboardFrameUpdate(_ notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

		let screenHeight = UIScreen.main.bounds.height
		var heightOffset = keyboardFrame.origin.y - screenHeight

		if #available(iOS 11.0, *) {
			heightOffset += min(abs(heightOffset), view.safeAreaInsets.bottom)
		}

		formKeyboardGuideBottomConstraint?.constant = heightOffset
	}

	/// Dismisses keyboard.
	@objc fileprivate func dismissKeyboard() {
		view.endEditing(true)
	}
}
