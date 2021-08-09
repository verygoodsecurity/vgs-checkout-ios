//
//  VGSDialogHelper.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Helper class to display alerts.
internal class VGSDialogHelper {

	internal static func showOkDialog(with title: String, message: String, okActionTitle: String, in viewController: UIViewController, completion: (() -> Void)?) {

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
}
