import Foundation

/// Loads shop data from a bundled JSON file.
/// Swap this for RemoteShopRepository when a live API is available.
struct LocalShopRepository: ShopRepositoryProtocol {
    private enum Constants {
        static let dataSourceFilename = "shops"
    }

    private let loader: JSONLoader

    init(loader: JSONLoader = JSONLoader()) {
        self.loader = loader
    }

    func fetchShops() async throws -> [Shop] {
        let dtos: [ShopDTO] = try await loader.load([ShopDTO].self, from: Constants.dataSourceFilename)
        return dtos.map { $0.toDomain() }
    }
}
