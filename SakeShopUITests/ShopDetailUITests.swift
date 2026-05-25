import XCTest

// Accessibility identifier constants mirrored from AccessibilityID in the app target.
private enum ID {
    static let scrollView = "shopList_scrollView"
    static let shopRow    = "shopRow"
    static let detailView = "shopDetail_view"
    static let detailName = "shopDetail_name"
}

final class ShopDetailUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        navigateToFirstShopDetail()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    private func navigateToFirstShopDetail() {
        guard app.scrollViews[ID.scrollView].waitForExistence(timeout: 5) else { return }
        app.buttons.matching(identifier: ID.shopRow).firstMatch.tap()
        _ = app.otherElements[ID.detailView].waitForExistence(timeout: 3)
    }

    // MARK: - BDD: shop_detail.feature — "Display shop information"

    func test_detailScreen_isPresented() throws {
        // BDD: shop_detail.feature — Display shop information
        // Given I have navigated to a shop detail screen
        // Then I should see the shop detail view
        XCTAssertTrue(
            app.otherElements[ID.detailView].exists,
            "Detail view should be on screen"
        )
    }

    func test_detailScreen_displaysShopName() throws {
        // BDD: shop_detail.feature — Display shop information — I should see the shop name
        XCTAssertTrue(app.staticTexts[ID.detailName].exists, "Shop name should be visible on detail screen")
    }

    func test_detailScreen_displaysDescription() throws {
        // BDD: shop_detail.feature — Display shop information — I should see the shop description
        XCTAssertTrue(
            app.staticTexts["Sushi bar with a variety of sake options."].exists,
            "Shop description should be visible on detail screen"
        )
    }

    func test_detailScreen_displaysAddressTerm() throws {
        // BDD: shop_detail.feature — Display shop information — I should see the address
        XCTAssertTrue(
            app.staticTexts["Address"].exists,
            "Address term label should be visible in the definition list"
        )
    }

    func test_detailScreen_openInMapsButton_isVisible() throws {
        // BDD: shop_detail.feature — Open address in maps
        // Given I am on the shop detail screen
        // When I tap the address / CTA button
        // Then the device maps application should open
        XCTAssertTrue(
            app.buttons["Open in Maps"].exists,
            "'Open in Maps' CTA button should be visible when shop has location data"
        )
    }

    func test_detailScreen_websiteRow_isVisible() throws {
        // BDD: shop_detail.feature — Open website in browser
        // Given I am on the shop detail screen
        // Then the website row should be present
        XCTAssertTrue(
            app.staticTexts["Website"].exists,
            "Website term label should be visible when shop has a website"
        )
    }

    // MARK: - BDD: shop_detail.feature — "Open website in browser"

    func test_tapWebsite_presentsSafariView() throws {
        // BDD: shop_detail.feature — Open website in browser
        // When I tap the website button
        // Then the shop website should open in the default browser
        let websiteButton = app.buttons["www.sushinano.com"]
        guard websiteButton.waitForExistence(timeout: 3) else {
            XCTFail("Website button should exist for a shop with a URL")
            return
        }
        websiteButton.tap()
        // SafariView (SFSafariViewController) runs in a separate process, so its
        // own controls aren't queryable from the app's XCUI test bundle.
        // Verify the sheet was presented by confirming the detail view is no
        // longer hittable (covered by the sheet).
        let detailView = app.otherElements["shopDetail_view"]
        let covered = NSPredicate(format: "isHittable == false")
        let expectation = XCTNSPredicateExpectation(predicate: covered, object: detailView)
        XCTAssertEqual(
            XCTWaiter().wait(for: [expectation], timeout: 3),
            .completed,
            "In-app browser (SafariView) should cover the detail view after tapping the website"
        )
    }

    // MARK: - BDD: shop_detail.feature — "Handle missing shop picture gracefully"

    func test_shopWithNoPicture_showsPlaceholder() throws {
        // BDD: shop_detail.feature — Handle missing shop picture gracefully
        // Navigate to "Midori Nagano" which has picture: null in the JSON
        app.buttons["Back"].tap()
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 3))

        app.staticTexts["Midori Nagano"].tap()
        XCTAssertTrue(app.otherElements[ID.detailView].waitForExistence(timeout: 3))

        // The gradient placeholder renders — no crash and the detail view is fully visible
        XCTAssertTrue(app.staticTexts["Midori Nagano"].exists)
    }
}
