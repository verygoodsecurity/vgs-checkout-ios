//
//  CheckoutDemoDialogHelper.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Helper class to display alerts.
class CheckoutDemoDialogHelper {

	/// Presents error dialog with ok button.
	/// - Parameters:
	///   - message: `String` object, error message text.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - completion: `(() -> Void)?` object, completion block triggered on alert action button tap.
	static func presentErrorAlertDialog(with message: String, in viewController: UIViewController, completion: (() -> Void)?) {

		let title = "Something went wrong"
		let okButtonTitle = "Ok"
		presentAlertDialog(with: title, message: message, okActionTitle: okButtonTitle, in: viewController, completion: completion)
	}

	/// Presents dialog with ok button.
	/// - Parameters:
	///   - title: `String` object, alert title text.
	///   - message: `String` object, alert message text.
	///   - okActionTitle: `String` object, title for ok button.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - completion: `(() -> Void)?` object, completion block triggered on alert action button tap.
	static func presentAlertDialog(with title: String, message: String, okActionTitle: String, in viewController: UIViewController, completion: (() -> Void)?) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		if let popoverController = alert.popoverPresentationController {
			popoverController.sourceView = viewController.view //to set the source of your alert
			popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
			popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
		}

		let action = UIAlertAction(title: okActionTitle, style: .default) { _ in
			(completion)?()
		}

		alert.addAction(action)

		viewController.present(alert, animated: true, completion: nil)
	}

	/// Presents retry dialog with cancel and completion action.
	/// - Parameters:
	///   - title: `String` object, alert title text.
	///   - message: `String` object, alert message text.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - retryCompletion: `(() -> Void)?` object, completion block triggered on retry alert action button tap.
	static func displayRetryDialog(with title: String, message: String, in viewController: UIViewController, retryCompletion: (() -> Void)?) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		if let popoverController = alert.popoverPresentationController {
			popoverController.sourceView = viewController.view //to set the source of your alert
			popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
			popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
		}

		let retryAction = UIAlertAction(title: "Try again", style: .default) { _ in
			(retryCompletion)?()
		}

		alert.addAction(cancelAction)
		alert.addAction(retryAction)

		viewController.present(alert, animated: true, completion: nil)
	}
}
