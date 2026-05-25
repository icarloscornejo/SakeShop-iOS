import Foundation

/// Core domain entity representing a sake shop.
/// Shared across ShopList and ShopDetail features.
/// When features are extracted to SPM modules, this moves to a shared CoreDomain module.
struct Shop: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let description: String
    let picture: URL?
    let rating: Double
    let address: String
    let coordinate: Coordinate?
    let googleMapsLink: URL?
    let website: URL?
}
