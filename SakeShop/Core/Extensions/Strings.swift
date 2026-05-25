import Foundation

/// Type-safe wrapper for Localizable.strings.
/// All user-visible string literals in the app must be referenced through this enum.
enum Strings {

    enum Common {
        static let back           = NSLocalizedString("common.back",             comment: "Back button accessibility label")
        static let noPhoto        = NSLocalizedString("common.no_photo",         comment: "Badge shown when shop has no photo")
        static let imageLoadError = NSLocalizedString("common.image_load_error", comment: "Badge shown when shop image fails to load")
    }

    enum Error {
        static let dataNotFound    = NSLocalizedString("error.data_not_found",   comment: "Shown when local JSON file is missing")
        static let decodingFailed  = NSLocalizedString("error.decoding_failed",  comment: "Shown when JSON structure is invalid or malformed")
        static let unknown         = NSLocalizedString("error.unknown",           comment: "Fallback for unexpected errors")
    }

    enum ListHeader {
        static let switchToDark        = NSLocalizedString("list_header.switch_to_dark",        comment: "Accessibility label for theme toggle when current appearance is light or system")
        static let switchToLight       = NSLocalizedString("list_header.switch_to_light",       comment: "Accessibility label for theme toggle when current appearance is dark")
    }

    enum ShopList {
        static let navigationTitle = NSLocalizedString("shop_list.navigation_title", comment: "Navigation bar title for shop list screen")
        static let anIndexOf       = NSLocalizedString("shop_list.an_index_of",      comment: "Eyebrow label above the shop list title")
        static let listTitle       = NSLocalizedString("shop_list.title",            comment: "Main display title on the shop list screen")
        static let updatedDate     = NSLocalizedString("shop_list.updated_date",     comment: "Subtitle showing last update date")
        static let entriesFormat   = NSLocalizedString("shop_list.entries_format",   comment: "Format string for shop count — %d is replaced with the integer count")
        static let endOfList       = NSLocalizedString("shop_list.end_of_list",      comment: "Footer label shown at the end of the shop list")
        static let emptyTitle      = NSLocalizedString("shop_list.empty_title",      comment: "Title on empty state screen")
        static let emptyBody       = NSLocalizedString("shop_list.empty_body",       comment: "Body text on empty state screen")
        static let refresh         = NSLocalizedString("shop_list.refresh",          comment: "Refresh button label in empty state")
        static let errorTitle      = NSLocalizedString("shop_list.error_title",      comment: "Title on error state screen")
        static let errorBody       = NSLocalizedString("shop_list.error_body",       comment: "Body text on error state screen")
        static let retry           = NSLocalizedString("shop_list.retry",            comment: "Retry button label")
    }

    enum ShopDetail {
        static let address     = NSLocalizedString("shop_detail.address",      comment: "Term label for address row in definition list")
        static let website     = NSLocalizedString("shop_detail.website",      comment: "Term label for website row in definition list")
        static let coordinates = NSLocalizedString("shop_detail.coordinates",  comment: "Term label for coordinates row in definition list")
        static let openInMaps  = NSLocalizedString("shop_detail.open_in_maps", comment: "CTA button label to open shop location in Maps app")
        static let visitWebsite = NSLocalizedString("shop_detail.visit_website", comment: "Website button label on detail screen")
    }
}
