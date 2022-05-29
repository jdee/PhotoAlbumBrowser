//
//  ContentView.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var photoManager: PhotoManager

    var body: some View {
        if photoManager.isLoaded {
            PhotoList(
                assets: $photoManager.assets,
                albumName: $photoManager.albumName
            )
            .ignoresSafeArea()
        }
        else {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotoManager())
    }
}
