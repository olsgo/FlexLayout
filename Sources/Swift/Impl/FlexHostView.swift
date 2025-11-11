//
//  FlexHostView.swift
//  FlexLayout
//
//  Created for macOS support
//  Copyright © 2025 FlexLayout. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias FlexHostView = UIView
#elseif os(macOS)
import AppKit
public typealias FlexHostView = NSView
#endif
