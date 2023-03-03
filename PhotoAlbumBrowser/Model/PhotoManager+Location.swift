//
//  PhotoManager+Location.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 5/24/22.
//

import CoreLocation

extension PhotoManager {
    static let countriesWithAdministrativeAreas = ["AU", "CA", "US"]

    /**
     Recursive function to pace reverse geolocation. Each item is requested only after the previous request returns.
     */
    func updateLocationNames() {
        updateLocationName(index: 0)
    }

    func updateLocationName(index: Int) {
        guard index < assets.count else { return }

        guard let location = assets[index].asset.location else {
            updateLocationName(index: index + 1)
            return
        }

        // Compute this once and reuse it
        let roundedCoordinate = location.roundedCoordinate

        if let name = geolocationCache[roundedCoordinate] {
            assets[index].locationName = name
            updateLocationName(index: index + 1)
            return
        }

        CLGeocoder().reverseGeocodeLocation(location.using(geoCoordinate: roundedCoordinate)) {
            placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                print("Error loading location name: \(String(describing: error))")
                DispatchQueue.main.async { self.updateLocationName(index: index + 1) }
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
                if Self.countriesWithAdministrativeAreas.contains(code), let area = placemark.administrativeArea {
                    name += "\(area) "
                }

                name += "\(code) "
            }

            name = name.trimmingCharacters(in: .whitespaces)

            DispatchQueue.main.async {
                self.assets[index].locationName = name
                self.geolocationCache[roundedCoordinate] = name
                self.updateLocationName(index: index + 1)
            }
        }
    }
}
