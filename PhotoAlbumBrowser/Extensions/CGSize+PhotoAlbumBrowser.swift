//
//  CGSize+PhotoAlbumBrowser.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/26/22.
//

import SwiftUI

extension CGSize {
    var isLandscape: Bool {
        width > height
    }

    var isPortrait: Bool {
        width < height
    }

    var isSquare: Bool {
        width == height
    }
}
