//
//  PhotoManager+Location.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/24/22.
//

import CoreLocation

extension PhotoManager {
    static let countriesWithAdminstrativeAreas = ["AU", "CA", "US"]

    func updateLocationNames() {
        for i in 0..<assets.count {
            updateLocationName(index: i)
        }
    }

    func updateLocationName(index: Int) {
        guard let location = assets[index].asset.location else {
            return
        }

        CLGeocoder().reverseGeocodeLocation(location) {
            placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                print("Error loading location name: \(String(describing: error))")
                return
            }

            var name = ""

            // City
            if let locality = placemark.locality {
                name += "\(locality) "
            }

            // Country
            if let code = placemark.isoCountryCode {
                // State (US,AU)/Province (CA)
                if Self.countriesWithAdminstrativeAreas.contains(code), let area = placemark.administrativeArea {
                    name += "\(area) "
                }

                name += "\(code) "
            }

            name = name.trimmingCharacters(in: .whitespaces)

            DispatchQueue.main.async {
                self.assets[index].locationName = name
            }
        }
    }
}
