//
//  Badge.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/25/22.
//

import SwiftUI

struct Badge: View {
    var tintColor: Color
    var foregroundColor: Color
    var image: Image

    init(image: Image, tintColor: Color = .brown, foregroundColor: Color = .accentColor) {
        self.image = image
        self.tintColor = tintColor
        self.foregroundColor = foregroundColor
    }

    init(systemImageName: String, tintColor: Color = .brown, foregroundColor: Color = .accentColor) {
        self.init(
            image: Image(systemName: systemImageName),
            tintColor: tintColor,
            foregroundColor: foregroundColor
        )
    }

    var bottomColor: Color {
        var hue = CGFloat.nan,
            saturation = CGFloat.nan,
            brightness = CGFloat.nan

        UIColor(tintColor).getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: nil
        )

        return .init(
            hue: hue,
            saturation: saturation,
            brightness: brightness*0.4,
            opacity: 1.0
        )
    }

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(
                colors:[tintColor, bottomColor]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(gradient)
                image
                    .resizable()
                    .frame(
                        width: 0.5*geometry.size.width,
                        height: 0.5*geometry.size.height
                    )
                    .foregroundColor(foregroundColor)
                    .shadow(
                        color: .black,
                        radius: 0.03*geometry.size.height,
                        x: 0,
                        y: 0.02*geometry.size.height
                    )
            }
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .background(.black)
            Badge(systemImageName: "livephoto", tintColor: .cyan, foregroundColor: .white)
                .frame(width: 200, height: 200)
        }

        Badge(systemImageName: "livephoto", tintColor: .cyan, foregroundColor: .white)
            .frame(width: 200, height: 200)

        ZStack {
            Rectangle()
                .background(.black)
            Badge(systemImageName: "pano")
                .frame(width: 36, height: 36)
        }

        Badge(systemImageName: "pano")
            .frame(width: 36, height: 36)
    }
}
