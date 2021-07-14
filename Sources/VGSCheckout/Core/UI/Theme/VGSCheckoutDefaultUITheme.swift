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
  public var textFieldBackgroundColor: UIColor = .lightGray
  
  public var textFieldBorderColor: UIColor = .gray
  
  public var textFieldTextColor: UIColor = .black
  
  public var textFieldPlaceholderColor: UIColor = .lightGray
  
  public var textFieldBorderErrorColor: UIColor = .red
  
  public var textFieldTextFont: UIFont = UIFont.systemFont(ofSize: 16)
  
  public var textFieldPlaceholderFont: UIFont =  UIFont.systemFont(ofSize: 16)
  
  /// Checkout View attributes

  public var checkoutViewBackgroundColor: UIColor = .white
  
  /// Error Label attributes
  public var checkoutErrorLabelFont: UIFont = .preferredFont(forTextStyle: .footnote)
  
  public var checkoutErrorLabelTextColor: UIColor = .systemRed
  
  /// Submit button attributes
  
  public var checkoutSubmitButtonBackgroundColor: UIColor = .systemPurple.withAlphaComponent(0.6)
  
  public var checkoutSubmitButtonSuccessBackgroundColor: UIColor = .systemGreen
  
  public var checkoutSubmitButtonTitleColor: UIColor = .white.withAlphaComponent(0.6)
  
  public var checkoutSubmitButtonTitleFont: UIFont = .preferredFont(forTextStyle: .callout)
}

