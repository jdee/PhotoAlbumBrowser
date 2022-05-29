//
//  PhotoCell.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/23/22.
//

import SwiftUI

struct PhotoCell: View {
    @Binding var assetInfo: AssetInfo
    var size: CGSize
    @State private var showOverlay = true

    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private var dimensions: String {
        guard let livePhoto = assetInfo.livePhoto else {
            return "\(assetInfo.asset.pixelWidth)x\(assetInfo.asset.pixelHeight)"
        }
        return "\(String(format: "%.f", livePhoto.size.width))x\(String(format: "%.f", livePhoto.size.height))"
    }

    private var lensModel: String {
        let replacement = "𝘧 "
        return assetInfo.lensModel.replacingOccurrences(of: "f/", with: replacement)
    }

    private var badgeImageName: String? {
        if assetInfo.asset.mediaSubtypes.contains(.photoLive) {
            return "livephoto"
        }
        if assetInfo.asset.mediaSubtypes.contains(.photoPanorama) {
            return "pano"
        }

        return nil
    }

    private var imageDescription: String {
        var result = "\(dimensions) "
        if !assetInfo.asset.mediaSubtypes.contains(.photoLive), !assetInfo.encoding.isEmpty {
            result += "\(assetInfo.encoding) "
        }
        if !assetInfo.subtype.isEmpty {
            result += "\(assetInfo.subtype) "
        }
        if !fileSize.isEmpty {
            result += "\(fileSize) "
        }

        result = result.trimmingCharacters(in: .whitespaces)
        result = "\(result)\n"

        if !lensModel.isEmpty {
            result += "\(lensModel) "
        }
        else if !assetInfo.cameraModel.isEmpty {
            result += "\(assetInfo.cameraModel) "
        }

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var fileSize: String {
        return assetInfo.assetSize.byteCount
    }

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().fill(Color.gray)

            if let livePhoto = assetInfo.livePhoto {
                LivePhotoView(
                    livephoto: livePhoto
                )
                .frame(width: size.width, height: size.height)
            }
            else if let asset = assetInfo.asset {
                Image(uiImage: PhotoManager.image(for: asset, size: size))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
            }
            else {
                Text("Image unavailable")
                    .padding()
            }

            if let date = assetInfo.asset?.creationDate {
                TextOverlay(
                    title: formatter.string(from: date),
                    subtitle: assetInfo.locationName,
                    moreText: imageDescription,
                    coordinate: assetInfo.asset?.location?.coordinate,
                    size: size,
                    systemImageName: badgeImageName
                )
                .frame(width: size.width)
                .opacity(showOverlay ? 1 : 0)
                .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                showOverlay.toggle()
            }
        }
    }
}

struct PhotoCell_Previews: PreviewProvider {
    static var previews: some View {
        let assetInfo = AssetInfo()
        PhotoCell(assetInfo: .constant(assetInfo), size: CGSize(width: 200, height: 200))
    }
}
