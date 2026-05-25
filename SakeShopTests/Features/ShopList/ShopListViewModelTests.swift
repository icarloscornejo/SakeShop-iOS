import XCTest
@testable import SakeShop

@MainActor
final class ShopListViewModelTests: XCTestCase {
    private var sut: ShopListViewModel!
    private var mockUseCase: MockShopListUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockShopListUseCase()
        sut = ShopListViewModel(useCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // BDD: "Show loading state while data is being fetched"
    func test_initialState_isLoading() {
        guard case .loading = sut.state else {
            XCTFail("Expected .loading, got \(sut.state)")
            return
        }
    }

    // BDD: "Successfully load shop data from local source"
    func test_loadShops_withShops_setsLoadedState() async {
        mockUseCase.stubbedShops = [ShopFactory.makeShop(name: "Shop A"), ShopFactory.makeShop(name: "Shop B")]

        await sut.loadShops()

        guard case .loaded(let shops) = sut.state else {
            XCTFail("Expected .loaded, got \(sut.state)")
            return
        }
        XCTAssertEqual(shops.count, 2)
    }

    // BDD: "Navigate to shop detail — detail screen displays selected shop data"
    func test_loadShops_preservesShopIdentity() async {
        let target = ShopFactory.makeShop(name: "Endo Brewery", rating: 4.5, address: "Nagano")
        mockUseCase.stubbedShops = [target]

        await sut.loadShops()

        guard case .loaded(let shops) = sut.state else {
            XCTFail("Expected .loaded")
            return
        }
        XCTAssertEqual(shops.first?.name, "Endo Brewery")
        XCTAssertEqual(shops.first?.address, "Nagano")
        XCTAssertEqual(shops.first?.rating, 4.5)
    }

    // BDD: "Handle empty data gracefully"
    func test_loadShops_withEmptyResult_setsEmptyState() async {
        mockUseCase.stubbedShops = []

        await sut.loadShops()

        guard case .empty = sut.state else {
            XCTFail("Expected .empty, got \(sut.state)")
            return
        }
    }

    // BDD: "Handle data loading error"
    func test_loadShops_withError_setsErrorState() async {
        mockUseCase.shouldThrow = AppError.dataNotFound

        await sut.loadShops()

        guard case .error = sut.state else {
            XCTFail("Expected .error, got \(sut.state)")
            return
        }
    }

    // BDD: "Retry after error"
    func test_retry_afterError_recoversToLoadedState() async {
        mockUseCase.shouldThrow = AppError.dataNotFound
        await sut.loadShops()

        mockUseCase.shouldThrow = nil
        mockUseCase.stubbedShops = [ShopFactory.makeShop()]
        await sut.retry()

        XCTAssertEqual(mockUseCase.executeCallCount, 2)
        guard case .loaded = sut.state else {
            XCTFail("Expected .loaded after retry")
            return
        }
    }
}
