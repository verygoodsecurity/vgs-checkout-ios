//
//  Storage.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Class Responsible for storing elements registered with VGSCollect instance
internal class Storage {
    
    var textFields = [VGSTextField]()
    var files = BodyData()
    
    func addTextField(_ textField: VGSTextField) {
        if textFields.filter({ $0 == textField }).count == 0 {
            textFields.append(textField)
        }
    }
    
    func removeTextField(_ textField: VGSTextField) {
        if let index = textFields.firstIndex(of: textField) {
            textFields.remove(at: index)
        }
    }
  
    func removeAllTextFields() {
      textFields = [VGSTextField]()
    }
    
    func removeFiles() {
        files = BodyData()
    }
}
