import Foundation
@testable import SakeShop

final class MockShopRepository: ShopRepositoryProtocol {
    var stubbedShops: [Shop] = []
    var shouldThrow: Error?
    private(set) var fetchCallCount = 0

    func fetchShops() async throws -> [Shop] {
        fetchCallCount += 1
        if let error = shouldThrow { throw error }
        return stubbedShops
    }
}
