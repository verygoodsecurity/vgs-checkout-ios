//
//  Sequence+Extensions.swift
//  VGSCheckoutSDK
//


import Foundation

internal extension Sequence where Element: Hashable {
  /// Returns unique elements in sequance.
  func uniqued() -> [Element] {
    var set = Set<Element>()
   return filter { set.insert($0).inserted }
  }
}
