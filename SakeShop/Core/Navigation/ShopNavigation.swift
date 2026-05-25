import Foundation

/// Carries a shop plus its position in the list through SwiftUI's value-based navigation.
/// Separating navigation metadata (index, total) from the domain model (Shop) avoids
/// coupling the detail screen's ViewModel to list-level concerns.
struct ShopNavigation: Hashable {
    let shop: Shop
    /// 1-based position of this shop in the currently displayed list.
    let index: Int
    /// Total number of shops in the list (for the "01 / 10" counter).
    let total: Int
}
