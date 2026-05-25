import Foundation
import Combine

@MainActor
final class ShopListViewModel: ObservableObject {
    enum ViewState {
        case loading
        case loaded([Shop])
        case empty
        case error(String)
    }

    @Published private(set) var state: ViewState = .loading

    private let useCase: ShopListUseCaseProtocol

    init(useCase: ShopListUseCaseProtocol) {
        self.useCase = useCase
    }

    func loadShops() async {
        state = .loading
        do {
            let shops = try await useCase.execute()
            state = shops.isEmpty ? .empty : .loaded(shops)
        } catch let error as AppError {
            state = .error(error.errorDescription ?? Strings.Error.unknown)
        } catch {
            state = .error(Strings.Error.unknown)
        }
    }

    func retry() async {
        await loadShops()
    }
}
