//
//  PhotoManager.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/23/22.
//

import SwiftUI
import Photos

final class PhotoManager: ObservableObject {
    @Published var albumName = Bundle.main.object(forInfoDictionaryKey: "album_name") as? String ?? Bundle.main.name ?? String()
    @Published var isAuthorized = PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
    @Published var isLoaded = false
    @Published var assets = [AssetInfo]()

    var geolocationCache = [GeolocationCoordinate: String]()

    init(loadImmediately: Bool = false) {
        if loadImmediately {
            load()
        }
    }

    func ensureAuthorization(callback: @escaping (Bool)->()) {
        guard !isAuthorized else {
            callback(true)
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            // callback on background thread
            callback(status == .authorized)

            DispatchQueue.main.async {
                self.isAuthorized = status == .authorized
            }

            guard status != .authorized else { return }
            print("Authorization failed")
        }
    }

    func reload(callback: (([AssetInfo])->())? = nil) {
        isLoaded = false
        assets = []
        load(callback: callback)
    }

    func load(callback: (([AssetInfo])->())? = nil) {
        guard !isLoaded else {
            callback?(assets)
            return
        }

        assets = []

        ensureAuthorization {
            status in

            // Can be called back here on the main thread. Dispatch these queries to the background.
            DispatchQueue.global(qos: .default).async {
                guard status else {
                    callback?([])
                    return
                }
                // now we're authorized

                // query for PHAssetCollection with localizedTitle
                let collectionOptions = PHFetchOptions()
                if !self.albumName.isEmpty {
                    collectionOptions.predicate = NSPredicate(format: "localizedTitle = %@", self.albumName)
                }
                collectionOptions.fetchLimit = 1

                var collectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: collectionOptions)
                if collectionResult.count == 0 {
                    print("Album named \"\(self.albumName)\" not found. Loading first smart album.")
                    let collectionOptionsWithoutName = PHFetchOptions()
                    collectionOptions.fetchLimit = 1
                    collectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: collectionOptionsWithoutName)
                }

                guard let collection = collectionResult.firstObject else {
                    print("No album found")
                    callback?([])
                    return
                }

                // now get all the PHAssets for still images in the PHAssetCollection
                let assetOptions = PHFetchOptions()
                assetOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                assetOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let assetResult = PHAsset.fetchAssets(in: collection, options: assetOptions)
                print("Found \(assetResult.count) assets in \(collection.localizedTitle ?? "unknown") album")
                let indexSet = IndexSet(integersIn: 0..<assetResult.count)

                DispatchQueue.main.async {
                    self.albumName = collection.localizedTitle ?? String()
                    self.assets = assetResult.objects(at: indexSet).map { AssetInfo(asset: $0) }
                    self.updateLocationNames()
                    self.updateMetadata()
                    self.isLoaded = true

                    callback?(self.assets)

                    /*
                     // Dump out properties from CoreImage
                     self.assets.forEach { $0.printMetadata() }
                     // */
                }
            }
        }
    }

    static func image(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode = .aspectFill) -> UIImage {
        var result = UIImage()

        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: options
        ) { image, info in
            if let image = image {
                result = image
            }
        }

        return result
    }

    func updateMetadata() {
        for i in 0..<assets.count {
            assets[i].asset?.requestContentEditingInput(with: nil) {
                input, info in
                if let url = input?.fullSizeImageURL {
                    self.assets[i].ciImage = CIImage(contentsOf: url)
                }

                self.assets[i].livePhoto = input?.livePhoto
            }

            assets[i].asset.getAssetSize { size in
                DispatchQueue.main.async {
                    self.assets[i].assetSize = size
                }
            }
        }
    }
}
