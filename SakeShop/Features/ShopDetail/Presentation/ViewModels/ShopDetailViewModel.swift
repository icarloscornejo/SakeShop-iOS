import Foundation
import Combine

/// No async loading needed — data arrives fully formed from ShopList.
/// Use case handles URL validation and display transformation.
@MainActor
final class ShopDetailViewModel: ObservableObject {
    @Published private(set) var displayData: ShopDetailDisplayData

    init(shop: Shop, useCase: ShopDetailUseCaseProtocol) {
        self.displayData = useCase.execute(shop: shop)
    }
}
