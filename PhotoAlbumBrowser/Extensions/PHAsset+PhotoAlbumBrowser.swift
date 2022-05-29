//
//  PHAsset+PhotoAlbumBrowser.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/26/22.
//

import Photos

// https://stackoverflow.com/a/53122214
extension PHAsset {
    func printMetadata() {
        let options = PHContentEditingInputRequestOptions()

        requestContentEditingInput(with: options) { contentEditingInput, _ in
            print(String(describing: self))
            guard let url = contentEditingInput?.fullSizeImageURL else { return }
            print(" \(url)")
            guard let img = CIImage(contentsOf: url) else { return }
            print(String(describing: img.properties))
        }
    }

    func getCIImage(callback: @escaping (CIImage?)->()) {
        let options = PHContentEditingInputRequestOptions()

        requestContentEditingInput(with: options) { contentEditingInput, _ in
            guard let url = contentEditingInput?.fullSizeImageURL else {
                callback(nil)
                return
            }

            // print("Loading \(url)")
            let img = CIImage(contentsOf: url)
            callback(img)
        }
    }

    func getAssetSize(callback: @escaping (UInt64)-> ()) {
        var dataSize: UInt64 = 0
        let resources = PHAssetResource.assetResources(for: self)
        var complete = 0
        resources.forEach { assetResource in
            PHAssetResourceManager.default().requestData(for: assetResource, options: nil) { data in
                dataSize += UInt64(data.count)
            } completionHandler: { error in
                complete += 1
                if complete >= resources.count {
                    callback(dataSize)
                }
            }
        }
    }
}
