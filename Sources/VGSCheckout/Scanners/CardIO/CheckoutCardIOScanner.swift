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
import CardIO

//let view = CardIOView(frame: .zero)

public class VGSCheckout {

	public enum CardScanner {
		case cardIO
		case bouncer
	}

	public func presentCheckout(from viewController: UIViewController, cardScanner: CardScanner?) {
		guard let scanner = cardScanner else {
			return
		}
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
