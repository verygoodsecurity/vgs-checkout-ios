//
//  VGSCheckoutTextFieldThemeProtocol.swift
//  VGSCheckoutSDK
//


import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Defines UI Theme for text field.
public protocol VGSCheckoutTextFieldThemeProtocol {

  /// Colors.

  /// The textfield’s background color.
  var textFieldBackgroundColor: UIColor { get set }

  /// The textfield’s border background color.
  var textFieldBorderColor: UIColor { get set }

  /// The textfield’s focus state color.
  var textFieldFocusedColor: UIColor { get set }

  /// The text color of the textfield hint (above the text field).
  var textFieldHintTextColor: UIColor { get set }

  /// The text color of the textfield.
  var textFieldTextColor: UIColor { get set }

  /// The textfield’s error color.
  var textFieldErrorColor: UIColor { get set }

  /// Fonts.

  /// The font of the textfield.
  var textFieldTextFont: UIFont { get set }

  /// The font of the textfield hint (above the text field).
  var textFieldHintTextFont: UIFont { get set }

  /// The font of the error label.
  var textFieldErrorLabelFont: UIFont { get set }
}
