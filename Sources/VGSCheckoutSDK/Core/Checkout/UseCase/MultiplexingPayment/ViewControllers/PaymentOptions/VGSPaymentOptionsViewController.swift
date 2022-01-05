//
//  VGSPaymentOptionsViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

internal class VGSPaymentOptionsViewController: UIViewController {

	fileprivate let mainView: VGSPaymentOptionsMainView

	// MARK: - Initialization

	init(paymentService: VGSCheckoutPaymentService) {
		mainView = VGSPaymentOptionsMainView(theme: paymentService.uiTheme)
		super.init(nibName: nil, bundle: nil)
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(mainView)
		mainView.checkout_constraintViewToSuperviewEdges()
	}
}
