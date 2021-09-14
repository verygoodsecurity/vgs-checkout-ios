//
//  VGSExpDateConfiguration.swift
//  VGSCheckout
//
//  Created by Dima on 22.01.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// A class responsible for configuration `VGSTextField` with `fieldType = .expDate`. Extends `VGSConfiguration` class.
internal final class VGSExpDateConfiguration: VGSConfiguration, VGSCheckoutFormatSerializableProtocol {

	/// Initializer.
	/// - Parameters:
	///   - checkoutExpDateOptions: `VGSCheckoutExpirationDateOptions` object, exp date options.
	///   - collect: `VGSCollect` object, collect instance.
	convenience init(checkoutExpDateOptions: VGSCheckoutExpirationDateOptions, collect: VGSCollect) {
		self.init(collector: collect, fieldName: checkoutExpDateOptions.fieldName)
		serializers = checkoutExpDateOptions.serializers
		inputDateFormat = checkoutExpDateOptions.inputDateFormat
		outputDateFormat = checkoutExpDateOptions.outputDateFormat
	}

	/// Initializer.
	/// - Parameters:
	///   - vgs: `VGSCollect` object, collect instance.
	///   - fieldName: `String` object, fieldname
	override internal init(collector vgs: VGSCollect, fieldName: String) {
		super.init(collector: vgs, fieldName: fieldName)
	}

  /// Input Source type. Default is `VGSTextFieldInputSource.datePicker`.
	internal var inputSource: VGSTextFieldInputSource = .datePicker
  
  /// Input date format to convert.
	internal var inputDateFormat: VGSCheckoutCardExpDateFormat?
  
  /// Output date format.
	internal var outputDateFormat: VGSCheckoutCardExpDateFormat?
  
  /// Output date format.
	internal var serializers: [VGSCheckoutFormatSerializerProtocol] = []
  
  /// `FieldType.expDate` type of `VGSTextField` configuration.
  override internal var type: FieldType {
    get { return .expDate }
    set {}
  }
  
  // MARK: - `VGSExpDateConfiguration` implementation
  
  /// Serialize Expiration Date
  internal func serialize(_ content: String) -> [String: Any] {
    var result = [String: Any]()
    for serializer in serializers {
      if let serializer = serializer as? VGSCheckoutExpDateSeparateSerializer {
        /// remove dividers
        var dateDigitsString = content.digits
        
        /// get output date format, if not set - use default
        let outputDateFormat = outputFormat ?? .shortYear
        /// check output date components length
        let outputMonthDigits = outputDateFormat.monthCharacters
        let outputYearDigits = outputDateFormat.yearCharacters
        
        let mth: String
        let year: String
        if outputDateFormat.isYearFirst {
          /// take month digitis
          year = String(dateDigitsString.prefix(outputYearDigits))
          /// remove month digits
          dateDigitsString = String(dateDigitsString.dropFirst(outputYearDigits))
          /// take year digitis
          mth = String(dateDigitsString.prefix(outputMonthDigits))
        } else {
          /// take month digitis
          mth = String(dateDigitsString.prefix(outputMonthDigits))
          /// remove month digits
          dateDigitsString = String(dateDigitsString.dropFirst(outputMonthDigits))
          /// take year digitis
          year = String(dateDigitsString.prefix(outputYearDigits))
        }
        
        /// set result for specific fieldnames
        result[serializer.monthFieldName] = mth
        result[serializer.yearFieldName] = year
      }
    }
    return result
  }
  
  /// Returns if Content should be Serialized
  internal var shouldSerialize: Bool {
    return !serializers.isEmpty
  }
}

/// Implement `FormatConvertable` protocol.
extension VGSExpDateConfiguration: FormatConvertable {

  internal var outputFormat: VGSCheckoutCardExpDateFormat? {
    return outputDateFormat
  }

  internal var inputFormat: VGSCheckoutCardExpDateFormat? {
    return inputDateFormat
  }
  
  internal var convertor: TextFormatConvertor {
    return ExpDateFormatConvertor()
  }
}
