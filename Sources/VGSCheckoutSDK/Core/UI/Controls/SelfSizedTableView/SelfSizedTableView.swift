//
//  SelfSizedTableView.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Self sizing table view, autoexpand to its content size height.
internal class SelfSizedTableView: UITableView {

	/// no:doc
	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
		self.layoutIfNeeded()
	}

	/// no:doc
	override var contentSize: CGSize {
			didSet {
					invalidateIntrinsicContentSize()
			}
	}

	/// no:doc
	override var intrinsicContentSize: CGSize {
			layoutIfNeeded()
			return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
