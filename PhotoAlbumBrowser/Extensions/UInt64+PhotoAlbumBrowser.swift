//
//  UInt64+PhotoAlbumBrowser.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/26/22.
//

import Foundation

extension UInt64 {
    var byteCount: String {
        let kilobyte: UInt64 = 1024
        let megabyte = kilobyte * kilobyte
        let gigabyte = kilobyte * megabyte

        if self < kilobyte {
            return "\(self) B"
        }
        if self < megabyte {
            let value = Double(self)/Double(kilobyte)
            return "\(String(format: "%.f", value)) kB"
        }
        if self < gigabyte {
            let value = Double(self)/Double(megabyte)
            return "\(String(format: "%.2f", value).chomp("0").chomp(".")) MB"
        }
        let value = Double(self)/Double(gigabyte)
        return "\(String(format: "%.2f", value).chomp("0").chomp(".")) GB"
    }
}
