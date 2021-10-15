//
//  VGSCheckoutTextFieldThemeAdapterProtocol.swift
//  VGSCheckoutSDK
//


import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSCheckoutTextFieldThemeAdapterProtocol {
  /// Adapts `VGSCheckoutTextFieldThemeProtocol` for specifics `VGSCheckoutFieldUIState`.
  func adapt(theme: VGSCheckoutTextFieldThemeProtocol, for state: VGSCheckoutFieldUIState) -> VGSCheckoutTextFieldViewUIAttributesProtocol
}

extension VGSCheckoutTextFieldThemeAdapterProtocol {
  public func adapt(theme: VGSCheckoutTextFieldThemeProtocol, for state: VGSCheckoutFieldUIState) -> VGSCheckoutTextFieldViewUIAttributesProtocol {
    switch state {
    case .initial:
      return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
                                              textFieldBorderColor: theme.textFieldBorderColor,
                                              textFieldHintTextColor: theme.textFieldTextColor,
                                              textFieldTextColor: theme.textFieldTextColor,
                                              textFieldTextFont: theme.textFieldTextFont,
                                              textFieldHintTextFont: theme.textFieldHintTextFont,
                                              textFieldErrorLabelColor: theme.textFieldErrorColor,
                                              textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
    case .filled:
      return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
                                              textFieldBorderColor: theme.textFieldBorderColor,
                                              textFieldHintTextColor: theme.textFieldHintTextColor,
                                              textFieldTextColor: theme.textFieldTextColor,
                                              textFieldTextFont: theme.textFieldTextFont,
                                              textFieldHintTextFont: theme.textFieldHintTextFont,
                                              textFieldErrorLabelColor: theme.textFieldErrorColor,
                                              textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
    case .focused:
      return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
                                              textFieldBorderColor: theme.textFieldFocusedColor,
                                              textFieldHintTextColor: theme.textFieldFocusedColor,
                                              textFieldTextColor: theme.textFieldTextColor,
                                              textFieldTextFont: theme.textFieldTextFont,
                                              textFieldHintTextFont: theme.textFieldHintTextFont,
                                              textFieldErrorLabelColor: theme.textFieldErrorColor,
                                              textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
    case .invalid:
      return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
                                              textFieldBorderColor: theme.textFieldErrorColor,
                                              textFieldHintTextColor: theme.textFieldErrorColor,
                                              textFieldTextColor: theme.textFieldTextColor,
                                              textFieldTextFont: theme.textFieldTextFont,
                                              textFieldHintTextFont: theme.textFieldHintTextFont,
                                              textFieldErrorLabelColor: theme.textFieldErrorColor,
                                              textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
    }
  }
}

/// TextField editable UI Attributes protocol.
internal protocol VGSCheckoutTextFieldViewUIAttributesProtocol {
  /// The textfield’s background color.
  var textFieldBackgroundColor: UIColor { get set }

  /// The textfield’s border background color.
  var textFieldBorderColor: UIColor { get set }

  /// The text color of the textfield hint (above the text field).
  var textFieldHintTextColor: UIColor { get set }

  /// The text color of the textfield.
  var textFieldTextColor: UIColor { get set }

  /// The text color of the error label.
  var textFieldErrorLabelColor: UIColor { get set }

  /// Fonts.

  /// The font of the textfield.
  var textFieldTextFont: UIFont { get set }

  /// The font of the textfield hint (above the text field).
  var textFieldHintTextFont: UIFont { get set }

  /// The font of the error label.
  var textFieldErrorLabelFont: UIFont { get set }
}

internal struct VGSCheckoutTextFieldUIAttributes: VGSCheckoutTextFieldViewUIAttributesProtocol {

  internal var textFieldBackgroundColor: UIColor

  internal var textFieldBorderColor: UIColor

  internal var textFieldHintTextColor: UIColor

  internal var textFieldTextColor: UIColor

  internal var textFieldTextFont: UIFont

  internal var textFieldHintTextFont: UIFont

  internal var textFieldErrorLabelColor: UIColor

  internal var textFieldErrorLabelFont: UIFont
}



