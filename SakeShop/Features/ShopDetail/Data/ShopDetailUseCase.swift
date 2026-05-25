import Foundation

struct ShopDetailUseCase: ShopDetailUseCaseProtocol {
    func execute(shop: Shop) -> ShopDetailDisplayData {
        ShopDetailDisplayData(
            name: shop.name,
            description: shop.description,
            picture: shop.picture,
            rating: shop.rating,
            address: shop.address,
            mapsLink: shop.googleMapsLink,
            website: shop.website
        )
    }
}
