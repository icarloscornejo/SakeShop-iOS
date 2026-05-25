import Foundation

/// Business logic contract for the shop list screen.
protocol ShopListUseCaseProtocol {
    func execute() async throws -> [Shop]
}
