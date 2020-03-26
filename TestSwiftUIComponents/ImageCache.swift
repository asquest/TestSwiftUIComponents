//
//  ImageCache.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/26/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import Foundation
import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

class TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
