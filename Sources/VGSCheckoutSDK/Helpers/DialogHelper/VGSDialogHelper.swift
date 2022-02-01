//
//  VGSDialogHelper.swift
//  VGSCheckoutSDK

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Helper class to display alerts.
internal class VGSDialogHelper {

	/// Presents error dialog with ok button.
	/// - Parameters:
	///   - message: `String` object, error message text.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - completion: `(() -> Void)?` object, completion block triggered on alert action button tap.
	internal static func presentErrorAlertDialog(with message: String, in viewController: UIViewController, completion: (() -> Void)?) {

		let title = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_error_dialog_title_something_went_wrong_error")
		let okButtonTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_error_dialog_ok_button_title")

		presentAlertDialog(with: title, message: message, okActionTitle: okButtonTitle, in: viewController, completion: completion)
	}

	/// Presents dialog with ok button.
	/// - Parameters:
	///   - title: `String` object, alert title text.
	///   - message: `String` object, alert message text.
	///   - okActionTitle: `String` object, title for ok button.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - completion: `(() -> Void)?` object, completion block triggered on alert action button tap.
	internal static func presentAlertDialog(with title: String, message: String, okActionTitle: String, in viewController: UIViewController, completion: (() -> Void)?) {

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

	/// Presents error dialog with desctructive action.
	/// - Parameters:
	///   - title: `String` object, title text.
	///   - message: `String` object,  message text.
	///   - viewController: `UIViewController` object, controller to present alert from.
	///   - cancelActionTitle: `String` object, cancel action title text.
	///   - actionTitle: `String` object, action title text.
	///   - completion: `(() -> Void)?` object, completion block triggered on alert action button tap.
	static func presentDescturctiveActionAlert(with title: String, message: String, in viewController: UIViewController, cancelActionTitle: String, actionTitle: String, completion: @escaping  (() -> Void)) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		if let popoverController = alert.popoverPresentationController {
			popoverController.sourceView = viewController.view //to set the source of your alert
			popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
			popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
		}

		let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
		let destructiveAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
			completion()
		}

		alert.addAction(cancelAction)
		alert.addAction(destructiveAction)

		viewController.present(alert, animated: true, completion: nil)
	}
}
