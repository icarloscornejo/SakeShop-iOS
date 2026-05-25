import XCTest

// Accessibility identifier constants mirrored from AccessibilityID in the app target.
private enum ID {
    static let scrollView  = "shopList_scrollView"
    static let shopRow     = "shopRow"
    static let detailView  = "shopDetail_view"
    static let detailName  = "shopDetail_name"
}

final class ShopListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - BDD: shop_list.feature — "Display all shops"

    func test_shopList_isDisplayedOnLaunch() throws {
        // BDD: shop_list.feature — Display all shops
        // Given the app has shop data available
        // When I open the shop list
        // Then I should see all shops
        let scrollView = app.scrollViews[ID.scrollView]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5), "Shop list scroll view should appear after launch")
    }

    func test_shopRows_areVisible() throws {
        // BDD: shop_list.feature — Display all shops — each shop item displays the name
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        let rows = app.buttons.matching(identifier: ID.shopRow)
        XCTAssertGreaterThan(rows.count, 0, "At least one shop row should be visible")
    }

    func test_shopRow_displaysShopName() throws {
        // BDD: shop_list.feature — Display all shops — each shop item displays the name
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        XCTAssertTrue(app.staticTexts["Endo Brewery"].exists, "Shop name should be visible in the list")
    }

    func test_shopRow_displaysAddress() throws {
        // BDD: shop_list.feature — Display all shops — each shop item displays the address
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        XCTAssertTrue(
            app.staticTexts["〒382-0086 長野県須坂市大字須坂 29"].exists,
            "Shop address should be visible in the list row"
        )
    }

    // MARK: - BDD: shop_list.feature — "Navigate to shop detail"

    func test_tapShopRow_navigatesToDetailScreen() throws {
        // BDD: shop_list.feature — Navigate to shop detail
        // Given I am on the shop list screen
        // When I tap on a shop
        // Then I should be taken to the shop detail screen
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        app.buttons.matching(identifier: ID.shopRow).firstMatch.tap()

        XCTAssertTrue(
            app.otherElements[ID.detailView].waitForExistence(timeout: 3),
            "Detail screen should appear after tapping a shop row"
        )
    }

    func test_tapShopRow_detailDisplaysCorrectShopName() throws {
        // BDD: shop_list.feature — Navigate to shop detail
        // And the detail screen displays the name of the selected shop
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        let shopName = "信州スシサカバ 寿しなの"
        app.staticTexts[shopName].tap()

        let detailName = app.staticTexts[ID.detailName]
        XCTAssertTrue(detailName.waitForExistence(timeout: 3))
        XCTAssertEqual(detailName.label, shopName)
    }

    func test_backButton_returnsToShopList() throws {
        // BDD: shop_list.feature — Navigate to shop detail (return journey)
        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))

        app.buttons.matching(identifier: ID.shopRow).firstMatch.tap()
        XCTAssertTrue(app.otherElements[ID.detailView].waitForExistence(timeout: 3))

        app.buttons["Back"].tap()

        XCTAssertTrue(
            app.scrollViews[ID.scrollView].waitForExistence(timeout: 3),
            "Shop list should reappear after tapping Back"
        )
    }
}
