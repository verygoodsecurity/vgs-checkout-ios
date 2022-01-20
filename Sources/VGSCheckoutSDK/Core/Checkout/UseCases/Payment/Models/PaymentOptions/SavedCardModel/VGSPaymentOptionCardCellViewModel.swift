//
//  VGSPaymentOptionCardCellViewModel.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Card payment option cell view model.
internal struct VGSPaymentOptionCardCellViewModel {

	/// Card brand image.
	internal let cardBrandImage: UIImage?

	/// Card holder name text.
	internal let cardHolder: String?

	/// Last 4 and exp date 4 text.
	internal let last4AndExpDateText: String?

	/// Indicates selected state.
	internal var isSelected: Bool
}
