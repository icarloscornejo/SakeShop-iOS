import XCTest
@testable import SakeShop

final class AppErrorTests: XCTestCase {

    // BDD: "Handle data loading error" — error descriptions are localized, non-empty
    func test_dataNotFound_returnsNonEmptyDescription() {
        let error = AppError.dataNotFound

        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription!.isEmpty)
    }

    func test_decodingFailed_returnsNonEmptyDescription() {
        let underlying = NSError(domain: "test", code: 0)
        let error = AppError.decodingFailed(underlying)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription!.isEmpty)
    }

    func test_unknown_returnsNonEmptyDescription() {
        let underlying = NSError(domain: "test", code: 0)
        let error = AppError.unknown(underlying)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription!.isEmpty)
    }

    // Each case should produce a distinct user-facing message
    func test_allCases_haveDistinctDescriptions() {
        let underlying = NSError(domain: "test", code: 0)
        let descriptions = [
            AppError.dataNotFound.errorDescription,
            AppError.decodingFailed(underlying).errorDescription,
            AppError.unknown(underlying).errorDescription
        ]

        let unique = Set(descriptions.compactMap { $0 })
        XCTAssertEqual(unique.count, 3)
    }
}
