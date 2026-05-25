import Foundation

/// Type-safe wrapper for Localizable.strings.
/// iOS equivalent of Android's strings.xml.
enum Strings {
    enum Error {
        static let dataNotFound = NSLocalizedString("error.data_not_found", comment: "Shown when local JSON file is missing")
        static let decodingFailed = NSLocalizedString("error.decoding_failed", comment: "Shown when JSON structure is invalid or malformed")
        static let unknown = NSLocalizedString("error.unknown", comment: "Fallback for unexpected errors")
    }

    enum ShopList {
        static let emptyState = NSLocalizedString("shop_list.empty_state", comment: "Shown when shop list returns no results")
        static let errorState = NSLocalizedString("shop_list.error_state", comment: "Shown when shop list fails to load")
        static let retry = NSLocalizedString("shop_list.retry", comment: "Retry button label")
    }

    enum ShopDetail {
        static let visitWebsite = NSLocalizedString("shop_detail.visit_website", comment: "Website button label on detail screen")
    }
}
