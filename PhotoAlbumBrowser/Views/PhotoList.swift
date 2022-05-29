//
//  PhotoList.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/23/22.
//

import SwiftUI

struct PhotoList: View {
    @Binding var assets: [AssetInfo]
    @Binding var albumName: String

    // Generates the size using the specified width from the GeometryReader
    // and the aspect ratio from the corresponding PHAsset.
    private func cellSize(width: CGFloat, asset: AssetInfo) -> CGSize {
        CGSize(width: width, height: width * (CGFloat(asset.asset.pixelHeight) / CGFloat(asset.asset.pixelWidth)))
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    ForEach(0..<assets.count, id: \.self) { index in
                        PhotoCell(
                            assetInfo: $assets[index],
                            size: cellSize(width: geometry.size.width, asset: assets[index])
                        )
                        .id(index)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    proxy.scrollTo(0)
                                }
                            } label: {
                                Text(albumName)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct PhotoList_Previews: PreviewProvider {
    static var previews: some View {
        PhotoList(assets: .constant([]), albumName: .constant("Recents"))
    }
}
