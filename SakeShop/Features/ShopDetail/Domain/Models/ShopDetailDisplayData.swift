import Foundation

/// Display-ready model for the shop detail screen.
/// Encapsulates URL validation logic away from the View layer.
struct ShopDetailDisplayData: Equatable {
    let name: String
    let description: String
    let picture: URL?
    let rating: Double
    let address: String
    let mapsLink: URL?
    let website: URL?

    var isMapsLinkAvailable: Bool { mapsLink != nil }
    var isWebsiteAvailable: Bool { website != nil }
}
