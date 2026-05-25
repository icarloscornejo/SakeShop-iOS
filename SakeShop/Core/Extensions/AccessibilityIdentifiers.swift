import Foundation

/// Centralized string constants for accessibility identifiers.
/// Used by production views (.accessibilityIdentifier) and referenced by UITests as string literals.
enum AccessibilityID {

    enum ShopList {
        static let scrollView  = "shopList_scrollView"
        static let loadingView = "shopList_loadingView"
        static let emptyView   = "shopList_emptyView"
        static let errorView   = "shopList_errorView"
    }

    enum ShopRow {
        static let container = "shopRow"
    }

    enum ShopDetail {
        static let view = "shopDetail_view"
        static let name = "shopDetail_name"
    }
}
