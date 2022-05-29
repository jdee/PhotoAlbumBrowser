//
//  PhotoAlbumBrowserApp.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/29/22.
//

import SwiftUI

@main
struct PhotoAlbumBrowserApp: App {
    @StateObject private var photoManager = PhotoManager(loadImmediately: true)

    var body: some Scene {
        WindowGroup {
            NavigationView {
                GeometryReader { geometry in
                    ContentView()
                        .environmentObject(photoManager)
                        .navigationBarHidden(geometry.size.isLandscape)
                        .statusBar(hidden: geometry.size.isLandscape)
                }
            }
        }
    }
}
