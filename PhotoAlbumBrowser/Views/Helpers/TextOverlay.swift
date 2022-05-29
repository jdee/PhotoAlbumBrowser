//
//  TextOverlay.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/23/22.
//

import SwiftUI
import CoreLocation

struct TextOverlay: View {
    var title: String
    var subtitle: String
    var moreText: String
    var coordinate: CLLocationCoordinate2D?
    var size: CGSize
    var systemImageName: String?

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: size.height >= 100 ? .center : .top)
    }

    private var mapDimension: CGFloat {
        0.25 * size.width
    }

    private var badgeDimension: CGFloat {
        return 32
    }

    private var titleFont: Font {
        return .title
    }

    private var subtitleFont: Font {
        return .title2
    }

    private var moreTextFont: Font {
        return .body
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        if let systemImageName = systemImageName {
                            Badge(systemImageName: systemImageName)
                                .frame(width: badgeDimension, height: badgeDimension)
                        }
                        Text(title)
                            .font(titleFont)
                            .bold()
                    }
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(subtitleFont)
                            .fontWeight(.semibold)
                    }
                    if !moreText.isEmpty {
                        Text(moreText)
                            .font(moreTextFont)
                    }
                }
                .padding([.leading, .bottom, .top])

                if let coordinate = coordinate {
                    Spacer()
                    MapView(coordinate: coordinate)
                        .frame(width: mapDimension, height: mapDimension)
                        .opacity(0.5)
                }
            }
        }
        .foregroundColor(.white)
    }
}

struct TextOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TextOverlay(title: "Title", subtitle: "Subtitle", moreText: "Line 1\nLine 2", coordinate: CLLocationCoordinate2D(latitude: 45.5, longitude: -122.75), size: CGSize(width: 400, height: 400))
            .frame(width: 400, height: 400)
            .border(.black, width: 1)
    }
}
