//
//  VGSCollectFieldNameMappingPolicy+Extensions.swift
//  VGSCheckoutSDK
//

import Foundation

internal extension VGSCollectFieldNameMappingPolicy {
	init(mappingPolicy: VGSCheckoutDataMergePolicy) {
		switch mappingPolicy {
		case .flat:
			self = .flatJSON
		case .nestedJSON:
			self = .nestedJSON
		case .nestedWithArrayMerge:
			self = .nestedJSONWithArrayMerge
		case .nestedWithArrayOverwrite:
			self = .nestedJSONWithArrayOverwrite
		}
	}
}
