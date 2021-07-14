//
//  VGSCheckoutDefaultUITheme.swift
//  VGSCheckout
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Default Checkout UI Theme settings
public struct VGSCheckoutDefaultTheme: VGSCheckoutThemeProtocol {
  
  /// TextField attributes
  public var textFieldBackgroundColor: UIColor = .systemGray
  
  public var textFieldBorderColor: UIColor = .systemGray
  
  public var textFieldTextColor: UIColor = .vgsInputBlackTextColor
  
  public var textFieldPlaceholderColor: UIColor = .systemGray
  
  public var textFieldBorderErrorColor: UIColor = .systemRed
  
  public var textFieldTextFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
  
	public var textFieldPlaceholderFont: UIFont =  UIFont.preferredFont(forTextStyle: .body)
  
  /// Checkout View attributes

  public var checkoutViewBackgroundColor: UIColor = .vgsSystemBackground

	/// Form section title (Card details, Billing address etc).
	public var checkoutFormSectionTitle: UIFont = .preferredFont(forTextStyle: .subheadline)
  
  /// Error Label attributes
  public var checkoutErrorLabelFont: UIFont = .preferredFont(forTextStyle: .footnote)
  
  public var checkoutErrorLabelTextColor: UIColor = .systemRed
  
  /// Submit button attributes
  
  public var checkoutSubmitButtonBackgroundColor: UIColor = .systemPurple.withAlphaComponent(0.6)
  
  public var checkoutSubmitButtonSuccessBackgroundColor: UIColor = .systemGreen
  
  public var checkoutSubmitButtonTitleColor: UIColor = .lightText.withAlphaComponent(0.6)
  
  public var checkoutSubmitButtonTitleFont: UIFont = .preferredFont(forTextStyle: .callout)
}

// This code is taken from https://github.com/noahsark769/ColorCompatibility
// Thanks to Noah Gilmore.
// Copyright (c) 2019 Noah Gilmore <noah.w.gilmore@gmail.com>

public extension UIColor {
	static var vgsSystemBackground: UIColor {
			if #available(iOS 13, *) {
					return .systemBackground
			}
			return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
	}

	static var vgsInputBlackTextColor: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor {(traits) -> UIColor in
				return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
			}
		} else {
			return .black
		}
	}
}

