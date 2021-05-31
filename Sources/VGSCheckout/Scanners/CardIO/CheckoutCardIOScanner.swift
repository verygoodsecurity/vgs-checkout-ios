//
//  CheckoutCardIOScanner.swift
//  
//

import Foundation
#if os(iOS)
import UIKit
#endif

//#if canImport(CardIOSDK)
//import CardIOSDK
//#endif
//import CardIO

//let view = CardIOView(frame: .zero)

public class VGSCheckout {

	public enum CardScanner {
		case cardIO
		case bouncer
	}

	// MARK: - Initializer

	public init() {}

	// MARK: - Interface

	public func presentCheckout(from viewController: UIViewController, cardScanner: CardScanner?) {
		let checkoutVC = CheckoutViewController(cardScanner: cardScanner)
		checkoutVC.modalPresentationStyle = .fullScreen
		viewController.present(checkoutVC, animated: true, completion: nil)
	}

	public func present(from viewController: UIViewController, configuration: String) {

	}
}

internal class CheckoutViewController: UIViewController {

	fileprivate var cardScanner: VGSCheckout.CardScanner?

	internal init(cardScanner: VGSCheckout.CardScanner?) {
		self.cardScanner = cardScanner
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .yellow
		guard let scanner = cardScanner else {
			return
		}

		switch scanner {
		case .cardIO:
			#if canImport(CardIOSDK)
			  let view = CardIOView(frame: .zero)
			#endif
		case .bouncer:
			break
		}
	}
}
