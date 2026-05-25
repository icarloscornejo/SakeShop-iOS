import Foundation

/// Core domain entity representing a sake shop.
/// Shared across ShopList and ShopDetail features.
struct Shop: Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let picture: URL?
    let rating: Double
    let address: String
    let coordinates: [Double]
    let googleMapsLink: URL?
    let website: URL?
}
