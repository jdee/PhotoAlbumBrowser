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

    private func resetOverlays() {
        for i in 0..<assets.count {
            assets[i].isOverlayVisible = true
        }
    }

    // Generates the size using the specified width from the GeometryReader
    // and the aspect ratio from the corresponding PHAsset.
    private func cellSize(width: CGFloat, assetInfo: AssetInfo) -> CGSize {
        CGSize(width: width, height: width * (CGFloat(assetInfo.asset.pixelHeight) / CGFloat(assetInfo.asset.pixelWidth)))
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(assets.indices, id: \.self) { index in
                            PhotoCell(
                                assetInfo: $assets[index],
                                size: cellSize(
                                    width: geometry.size.width,
                                    assetInfo: assets[index]
                                )
                            )
                            .id(index)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    assets[index].isOverlayVisible.toggle()
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    proxy.scrollTo(0)
                                    resetOverlays()
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
