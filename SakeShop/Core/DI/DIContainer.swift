import Foundation
import Combine

/// Wires dependencies across the app.
/// Passed as @EnvironmentObject from SakeShopApp.
final class DIContainer: ObservableObject {
    func makeShopListViewModel() -> ShopListViewModel {
        ShopListViewModel(useCase: ShopListUseCase(repository: LocalShopRepository()))
    }

    func makeShopDetailViewModel(shop: Shop) -> ShopDetailViewModel {
        ShopDetailViewModel(shop: shop, useCase: ShopDetailUseCase())
    }
}
