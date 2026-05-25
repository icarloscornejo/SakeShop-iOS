import Foundation

/// Contract for any data source that provides shop data.
/// Implementations: LocalShopRepository (JSON), future RemoteShopRepository (API).
protocol ShopRepositoryProtocol {
    func fetchShops() async throws -> [Shop]
}
