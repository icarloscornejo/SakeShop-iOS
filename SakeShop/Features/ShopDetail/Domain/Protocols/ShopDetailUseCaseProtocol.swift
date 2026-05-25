import Foundation

/// Business logic contract for the shop detail screen.
/// Responsible for preparing display-ready data from a Shop entity.
protocol ShopDetailUseCaseProtocol {
    func execute(shop: Shop) -> ShopDetailDisplayData
}
