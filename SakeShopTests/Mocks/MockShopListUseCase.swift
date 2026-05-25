import Foundation
@testable import SakeShop

final class MockShopListUseCase: ShopListUseCaseProtocol {
    var stubbedShops: [Shop] = []
    var shouldThrow: Error?
    private(set) var executeCallCount = 0

    func execute() async throws -> [Shop] {
        executeCallCount += 1
        if let error = shouldThrow { throw error }
        return stubbedShops
    }
}
