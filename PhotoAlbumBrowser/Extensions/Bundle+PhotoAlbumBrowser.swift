//
//  Bundle+PhotoAlbumBrowser.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/26/22.
//

import Foundation

extension Bundle {
    var name: String? {
        object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
}
