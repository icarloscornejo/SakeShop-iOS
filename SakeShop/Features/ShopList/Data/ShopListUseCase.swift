import Foundation

struct ShopListUseCase: ShopListUseCaseProtocol {
    private let repository: ShopRepositoryProtocol

    init(repository: ShopRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Shop] {
        try await repository.fetchShops()
    }
}
