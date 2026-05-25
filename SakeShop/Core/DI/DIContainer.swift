import Foundation
import Combine

/// Wires dependencies across the app.
/// Passed as @EnvironmentObject from SakeShopApp.
final class DIContainer: ObservableObject {
    private let shopRepository: ShopRepositoryProtocol

    init() {
        #if DEBUG
        let mode = ProcessInfo.processInfo.environment[UITestingFlag.uitestMode]
        if mode == UITestingFlag.modeEmpty {
            shopRepository = EmptyShopRepository()
        } else if mode == UITestingFlag.modeError {
            shopRepository = ErrorShopRepository()
        } else {
            shopRepository = LocalShopRepository()
        }
        #else
        shopRepository = LocalShopRepository()
        #endif
    }

    func makeShopListViewModel() -> ShopListViewModel {
        ShopListViewModel(useCase: ShopListUseCase(repository: shopRepository))
    }

    func makeShopDetailViewModel(shop: Shop) -> ShopDetailViewModel {
        ShopDetailViewModel(shop: shop, useCase: ShopDetailUseCase())
    }
}
