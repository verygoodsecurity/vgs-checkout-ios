//
//  VGSFormViewController.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSFormViewController: UIViewController {

	// MARK: - Vars

	internal let formView = VGSFormView()
	private var formKeyboardGuideBottomConstraint: NSLayoutConstraint?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		addListeners()
	}

	// MARK: - Helpers

	internal func setupUI() {
		view.addSubview(formView)
		view.backgroundColor = .white
		formView.translatesAutoresizingMaskIntoConstraints = false

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

	internal func addListeners() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
																	 selector: #selector(handleKeyboardFrameUpdate(_:)),
																	 name: UIResponder.keyboardWillChangeFrameNotification,
																	 object: nil)
	}

	@objc private func handleKeyboardFrameUpdate(_ notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

		let screenHeight = UIScreen.main.bounds.height
		var heightOffset = keyboardFrame.origin.y - screenHeight

		if #available(iOS 11.0, *) {
			heightOffset += min(abs(heightOffset), view.safeAreaInsets.bottom)
		}

		formKeyboardGuideBottomConstraint?.constant = heightOffset
	}
}
