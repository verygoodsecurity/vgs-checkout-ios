//
//  VGSTextField+UIBuilder.swift
//  VGSCheckoutSDK
//


import Foundation
#if os(iOS)
import UIKit
#endif

internal extension VGSTextField {
  
    // MARK: - Text Attribute
  
    /// `VGSTextField` text font
    var font: UIFont? {
        get {
            return textField.font
        }
        set {
            textField.font = newValue
        }
    }
  
    /// `VGSTextField` text color
    @IBInspectable var textColor: UIColor? {
        get {
            return textField.textColor
        }
        set {
            textField.textColor = newValue
        }
    }
  
    // MARK: - UI Layer Attribute
  
    /// `VGSTextField` layer corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
  
    /// `VGSTextField` layer borderWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
  
    /// `VGSTextField` layer borderColor
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgcolor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgcolor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

	  /// :nodoc: Prepare `VGSTextField` for IB with custom styles.
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.cornerRadius = cornerRadius
    }
}
