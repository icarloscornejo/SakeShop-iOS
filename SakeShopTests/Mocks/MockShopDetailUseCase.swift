import Foundation
@testable import SakeShop

final class MockShopDetailUseCase: ShopDetailUseCaseProtocol {
    var stubbedDisplayData: ShopDetailDisplayData = ShopFactory.makeDisplayData()
    private(set) var executeCallCount = 0
    private(set) var lastShop: Shop?

    func execute(shop: Shop) -> ShopDetailDisplayData {
        executeCallCount += 1
        lastShop = shop
        return stubbedDisplayData
    }
}
