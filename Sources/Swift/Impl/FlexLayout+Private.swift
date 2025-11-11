//
//  FlexLayout+Private.swift
//  FlexLayout
//
//  Created by DION, Luc (MTL) on 2017-11-23.
//  Copyright © 2017 Mirego. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import yoga

extension Flex {
    func valueOrUndefined(_ value: CGFloat?) -> YGValue {
        if let value = value {
            return YGValue(value)
        } else {
            return YGValueUndefined
        }
    }
    
    func valueOrAuto(_ value: CGFloat?) -> YGValue {
        if let value = value {
            return YGValue(value)
        } else {
            return YGValueAuto
        }
    }
}
