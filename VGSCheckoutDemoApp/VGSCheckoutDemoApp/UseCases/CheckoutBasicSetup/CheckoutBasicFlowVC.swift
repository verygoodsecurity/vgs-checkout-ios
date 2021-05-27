//
//  CheckoutBasicFlowVC.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

class CheckoutBasicFlowVC: UIViewController {

	// MARK: - Vars

	/// Main view.
	fileprivate lazy var mainView: CheckoutFlowMainView = {
		let view = CheckoutFlowMainView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(mainView)
		mainView.checkoutDemo_constraintViewToSuperviewEdges()

		loadData()
	}

	// MARK: - Helpers

	/// Load orders data.
	private func loadData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}
}
