//
//  GeolocationCoordinate.swift
//  PhotoAlbumBrowser
//
//  Created by Jimmy Dee on 3/2/23.
//

import CoreLocation

extension CLLocation {
    /// Returns a coordinate equal to .coordinate with latitude and longitude rounded to GeolocationCoordinate.gridSizeDegrees
    var roundedCoordinate: GeolocationCoordinate {
        .init(location: self)
    }

    /// Returns a copy of this object with rounded coordinates
    var rounded: CLLocation {
        using(geoCoordinate: roundedCoordinate)
    }

    /// Returns a copy of this object using the (rounded) coordinates from geoCoordinate
    func using(geoCoordinate: GeolocationCoordinate) -> CLLocation {
        let rounded2d = CLLocationCoordinate2D(latitude: geoCoordinate.latitude, longitude: geoCoordinate.longitude)
        if let sourceInfo = sourceInformation {
            return .init(coordinate: rounded2d, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, courseAccuracy: courseAccuracy, speed: speed, speedAccuracy: speedAccuracy, timestamp: timestamp, sourceInfo: sourceInfo)
        }
        return .init(coordinate: rounded2d, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, courseAccuracy: courseAccuracy, speed: speed, speedAccuracy: speedAccuracy, timestamp: timestamp)
     }
}

/// Hashable rounded coordinate for use as a key in the Dictionary used as a geolocation cache. Divides the globe
/// into roughly rectangular regions of equal area, with latitudinal extent proportional to the secant of the latitude.
struct GeolocationCoordinate: Hashable {
    /// Longitudinal width of a grid region
    static let GridSizeDegrees: CLLocationDegrees = 5e-3 // About 0.5 km on a great circle

    /// Compare two GeolocationCoordinates.
    /// - Returns: true if the (rounded) latitude and longitude of both are equal; false otherwise
    static func == (lhs: GeolocationCoordinate, rhs: GeolocationCoordinate) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    /// The rounded latitude of this coordinate
    let latitude: CLLocationDegrees
    /// The rounded longitude of this coordinate, a multiple of gridSizeDegrees
    let longitude: CLLocationDegrees

    /// Initializes a ``GeolocationCoordinate`` from a CLLocationCoordinate2D,
    /// rounding the latitude and longitude
    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = Self.round(latitude: coordinate.latitude)
        longitude = Self.round(coordinate.longitude)
    }

    /// Initializes a ``GeolocationCoordinate`` from a CLLocation
    init(location: CLLocation) {
        self.init(location.coordinate)
    }

    /// Hashes by (rounded) latitude and longitude
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    /// Rounds the argument to a multiple of ``gridSizeDegrees``
    private static func round(_ component: CLLocationDegrees) -> CLLocationDegrees {
        floor(component / GridSizeDegrees) * GridSizeDegrees
    }

    private static let DegreesPerRadian = 180.0 / .pi

    /// Number of latitudinal intervals in a hemisphere. Results in square regions at the equator.
    /// Aspect ratio is the square of the secant of latitude. The ratio of the total longitudinal interval
    /// count in 2π to the total latitudianl interval count in π is π.
    private static let NumLatitudinalIntervals = DegreesPerRadian / GridSizeDegrees

    /// Rounds the ``latitude`` argument in intervals of equal axial distance, resulting in regions of equal area
    /// as the distance from the axis shrinks near the poles.
    private static func round(latitude: CLLocationDegrees) -> CLLocationDegrees {
        return asin(
            floor(sin(latitude / DegreesPerRadian) * NumLatitudinalIntervals + 0.5) / NumLatitudinalIntervals
        ) * DegreesPerRadian
    }
}
