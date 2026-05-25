import XCTest

// Accessibility identifier constants mirrored from AccessibilityID in the app target.
private enum ID {
    static let scrollView  = "shopList_scrollView"
    static let loadingView = "shopList_loadingView"
    static let emptyView   = "shopList_emptyView"
    static let errorView   = "shopList_errorView"
}

final class DataLoadingUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - BDD: data_loading.feature — "Successfully load shop data from local source"

    func test_successfulLoad_displaysShopList() throws {
        // BDD: data_loading.feature — Successfully load shop data from local source
        // Given the local shop data source is available
        // When the app initializes the shop list
        // Then all shops are loaded and displayed
        app.launch()

        XCTAssertTrue(
            app.scrollViews[ID.scrollView].waitForExistence(timeout: 5),
            "Shop list should be displayed when data loads successfully"
        )
    }

    // MARK: - BDD: data_loading.feature — "Handle empty data gracefully"

    func test_emptyData_displaysEmptyState() throws {
        // BDD: data_loading.feature — Handle empty data gracefully
        // Given the shop data source returns no shops
        // When I open the shop list
        // Then an empty state message is displayed
        app.launchEnvironment = ["UITESTING_MODE": "empty"]
        app.launch()

        XCTAssertTrue(
            app.otherElements[ID.emptyView].waitForExistence(timeout: 5),
            "Empty state view should be displayed when data source returns no shops"
        )
    }

    func test_emptyState_displaysRefreshButton() throws {
        // BDD: data_loading.feature — Handle empty data gracefully (refresh action available)
        app.launchEnvironment = ["UITESTING_MODE": "empty"]
        app.launch()

        XCTAssertTrue(app.otherElements[ID.emptyView].waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.buttons["Refresh"].exists,
            "Refresh button should be visible in the empty state"
        )
    }

    // MARK: - BDD: data_loading.feature — "Handle data loading error"

    func test_errorState_displaysErrorView() throws {
        // BDD: data_loading.feature — Handle data loading error
        // Given the shop data source fails to load
        // When I open the shop list
        // Then an error message is displayed to the user
        app.launchEnvironment = ["UITESTING_MODE": "error"]
        app.launch()

        XCTAssertTrue(
            app.otherElements[ID.errorView].waitForExistence(timeout: 5),
            "Error view should be displayed when the data source throws"
        )
    }

    func test_errorState_displaysRetryButton() throws {
        // BDD: data_loading.feature — Handle data loading error (retry action available)
        app.launchEnvironment = ["UITESTING_MODE": "error"]
        app.launch()

        XCTAssertTrue(app.otherElements[ID.errorView].waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.buttons["Retry"].exists,
            "Retry button should be visible in the error state"
        )
    }

    // MARK: - BDD: data_loading.feature — "Retry after error"

    func test_retryButton_triggersReload() throws {
        // BDD: data_loading.feature — Retry after error
        // Given an error message is displayed to the user
        // When I tap the retry button
        // Then the app attempts to load shop data again
        // (Repository still throws, so error state reappears — confirming the retry cycle ran)
        app.launchEnvironment = ["UITESTING_MODE": "error"]
        app.launch()

        XCTAssertTrue(app.otherElements[ID.errorView].waitForExistence(timeout: 5))
        app.buttons["Retry"].tap()

        XCTAssertTrue(
            app.otherElements[ID.errorView].waitForExistence(timeout: 5),
            "Error view should reappear after retry when the data source still fails"
        )
    }

    // MARK: - BDD: data_loading.feature — "Handle partial data with null fields"

    func test_shopWithNullPicture_doesNotCrash() throws {
        // BDD: data_loading.feature — Handle partial data with null fields
        // "Midori Nagano" has picture: null in shops.json
        // Given a shop in the data source has one or more null optional fields
        // When the app loads that shop
        // Then the shop is displayed without crashing
        app.launch()

        XCTAssertTrue(app.scrollViews[ID.scrollView].waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.staticTexts["Midori Nagano"].exists,
            "Shop with null picture should appear in the list without crashing"
        )
    }
}
