//
//  String+PhotoAlbumBrowser.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/26/22.
//

import Foundation

extension String {
    func chomp(_ trailing: String = " ") -> String {
        guard hasSuffix(trailing) else { return self }
        let substring = prefix(count - trailing.count)
        return String(substring).chomp(trailing)
    }
}
