//
//  Typealias.swift
//  Design
//
//  Created by AtenB on 10/18/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

#if os(iOS)
import UIKit

public typealias PImage = UIImage
public typealias PColor = UIColor
public typealias PFont = UIFont

#elseif os(macOS)
import AppKit

public typealias PImage = NSImage
public typealias PColor = NSColor
public typealias PFont = NSFont
#endif
