import Foundation

/// Geographic coordinate validated at parse time.
/// Nil in Shop.coordinate signals the raw data was missing or malformed.
struct Coordinate: Equatable, Hashable {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    /// Returns nil when the array doesn't carry exactly two in-range values.
    init?(from values: [Double]) {
        guard values.count == 2,
              (-90...90).contains(values[0]),
              (-180...180).contains(values[1]) else { return nil }
        self.init(latitude: values[0], longitude: values[1])
    }
}
