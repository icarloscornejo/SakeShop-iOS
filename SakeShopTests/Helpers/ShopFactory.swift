import Foundation
@testable import SakeShop

/// Test data builder for Shop and related models.
enum ShopFactory {
    static func makeShop(
        id: String = "test-shop-id",
        name: String = "Test Shop",
        description: String = "Test description",
        picture: URL? = URL(string: "https://example.com/image.jpg"),
        rating: Double = 4.0,
        address: String = "Test Address",
        coordinate: Coordinate? = nil,
        googleMapsLink: URL? = URL(string: "https://maps.app.goo.gl/test"),
        website: URL? = URL(string: "https://example.com")
    ) -> Shop {
        Shop(
            id: id,
            name: name,
            description: description,
            picture: picture,
            rating: rating,
            address: address,
            coordinate: coordinate,
            googleMapsLink: googleMapsLink,
            website: website
        )
    }

    static func makeDisplayData(
        name: String = "Test Shop",
        description: String = "Test description",
        picture: URL? = URL(string: "https://example.com/image.jpg"),
        rating: Double = 4.0,
        address: String = "Test Address",
        mapsLink: URL? = URL(string: "https://maps.app.goo.gl/test"),
        website: URL? = URL(string: "https://example.com")
    ) -> ShopDetailDisplayData {
        ShopDetailDisplayData(
            name: name,
            description: description,
            picture: picture,
            rating: rating,
            address: address,
            mapsLink: mapsLink,
            website: website
        )
    }
}
