#if DEBUG
import Foundation

/// Returns an empty shop list. Activated via --uitesting-empty launch argument.
struct EmptyShopRepository: ShopRepositoryProtocol {
    func fetchShops() async throws -> [Shop] { [] }
}

/// Always throws a dataNotFound error. Activated via --uitesting-error launch argument.
struct ErrorShopRepository: ShopRepositoryProtocol {
    func fetchShops() async throws -> [Shop] {
        throw AppError.dataNotFound
    }
}

enum UITestingFlag {
    static let uitestMode  = "UITESTING_MODE"
    static let modeEmpty   = "empty"
    static let modeError   = "error"
}
#endif
