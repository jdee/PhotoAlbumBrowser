//
//  AssetInfo.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/25/22.
//

import Photos

/**
 Information about an individual photo asset.
 */
struct AssetInfo {
    /**
     The PHAsset returned by querying the Photo Library.
     */
    var asset: PHAsset!

    /**
     The CIImage associated with this asset
     */
    var ciImage: CIImage?

    /**
     The total size in bytes of all resources associated with the asset.
     */
    var assetSize: UInt64 = 0

    /**
     Live photo associated with this asset
     */
    var livePhoto: PHLivePhoto?

    /**
     The location name returned by reverse geocoding from asset.location.
     */
    var locationName = ""

    /**
     The local file: URL for the image. Used to determine file type and encoding.
     */
    var url: URL? {
        ciImage?.url
    }

    /**
     A dictionary of metadata properties associated with the asset.
     */
    var properties: [String: Any?]? {
        ciImage?.properties
    }

    /**
     The file extension of the local file: URL.
     */
    var fileType: String? {
        url?.pathExtension
    }

    /**
     A string representation of the image encoding based on the file extension.
     */
    var encoding: String {
        switch fileType?.lowercased() {
        case "jpg", "jpeg":
            return "JPEG"
        case "heic":
            return "HEIF"
        case "png":
            return "PNG"
        case "gif":
            return "GIF"
        default:
            return ""
        }
    }

    /**
     A string representing the image subtype, including pano, HDR, screenshot, depth effect and live.
     */
    var subtype: String {
        var value = ""

        if asset?.mediaSubtypes.contains(.photoPanorama) ?? false {
            value += "pano "
        }
        if asset?.mediaSubtypes.contains(.photoHDR) ?? false {
            value += "HDR "
        }
        if asset?.mediaSubtypes.contains(.photoLive) ?? false {
            value += "live "
        }
        if asset?.mediaSubtypes.contains(.photoScreenshot) ?? false {
            value += "screenshot "
        }
        if asset?.mediaSubtypes.contains(.photoDepthEffect) ?? false {
            value += "depth effect "
        }

        return value.trimmingCharacters(in: .whitespaces)
    }

    /**
     The camera model used to take the original image, extracted from metadata properties.
     */
    var cameraModel: String {
        if let props = properties, let tiff = (props["{TIFF}"] ?? props["{Tiff}"]) as? [String: Any?], let make = tiff["Make"] as? String, let model = tiff["Model"] as? String {
            return "\(make) \(model)"
        }
        return String()
    }

    /**
     The lens model used to take the original image, extracted from metadata properties.
     */
    var lensModel: String {
        if let exif = properties?["{Exif}"] as? [String: Any?], let model = exif["LensModel"] as? String {
            return model
        }
        return String()
    }
}
