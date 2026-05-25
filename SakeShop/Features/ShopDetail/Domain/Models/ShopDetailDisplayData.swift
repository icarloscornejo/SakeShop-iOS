import Foundation

/// Display-ready model for the shop detail screen.
/// Encapsulates URL validation and display-formatting logic away from the View layer.
struct ShopDetailDisplayData: Equatable {
    let name: String
    let description: String
    let picture: URL?
    let rating: Double
    let address: String
    let coordinate: Coordinate?
    let mapsLink: URL?
    let website: URL?

    var isMapsLinkAvailable: Bool { mapsLink != nil }
    var isWebsiteAvailable: Bool { website != nil }

    /// Website URL stripped of scheme and trailing slash for compact display.
    var displayWebsite: String {
        guard let website else { return "" }
        return website.absoluteString
            .replacingOccurrences(of: URLScheme.https, with: "")
            .replacingOccurrences(of: URLScheme.http, with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: URLScheme.trailingSlash))
    }

    /// Formatted coordinate string, or nil when coordinate data is unavailable.
    var coordinateText: String? {
        guard let coord = coordinate else { return nil }
        return String(format: Format.coordinate, coord.latitude, coord.longitude)
    }

    // MARK: - Private constants

    private enum URLScheme {
        static let https        = "https://"
        static let http         = "http://"
        static let trailingSlash = "/"
    }

    private enum Format {
        static let coordinate = "%.3f, %.3f"
    }
}
