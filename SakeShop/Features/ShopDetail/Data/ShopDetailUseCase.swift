import Foundation

struct ShopDetailUseCase: ShopDetailUseCaseProtocol {
    func execute(shop: Shop) -> ShopDetailDisplayData {
        ShopDetailDisplayData(
            name: shop.name,
            description: shop.description,
            picture: shop.picture,
            rating: shop.rating,
            address: shop.address,
            coordinate: shop.coordinate,
            mapsLink: mapsURL(for: shop),
            website: shop.website
        )
    }

    // MARK: - Maps URL resolution

    /// Builds a maps URL from coordinates when available (opens Apple Maps natively),
    /// falling back to the raw Google Maps link when coordinates are absent.
    private func mapsURL(for shop: Shop) -> URL? {
        if let coord = shop.coordinate {
            return appleMapsURL(coordinate: coord, name: shop.name)
        }
        return shop.googleMapsLink
    }

    private func appleMapsURL(coordinate: Coordinate, name: String) -> URL? {
        var components = URLComponents()
        components.scheme = "maps"
        components.host = ""
        components.queryItems = [
            URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "q", value: name),
        ]
        return components.url
    }
}
