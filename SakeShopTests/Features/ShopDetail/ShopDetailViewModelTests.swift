import XCTest
@testable import SakeShop

@MainActor
final class ShopDetailViewModelTests: XCTestCase {
    private var sut: ShopDetailViewModel!
    private var mockUseCase: MockShopDetailUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockShopDetailUseCase()
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // BDD: "Display shop information"
    func test_init_callsUseCaseOnce() {
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    // BDD: "Navigate to shop detail — detail screen displays name/address/rating of selected shop"
    func test_displayData_reflectsSelectedShop() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(name: "Miyasaka Brewery", rating: 4.2, address: "Suwa City")
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertEqual(sut.displayData.name, "Miyasaka Brewery")
        XCTAssertEqual(sut.displayData.address, "Suwa City")
        XCTAssertEqual(sut.displayData.rating, 4.2)
    }

    // BDD: "Open address in maps"
    func test_isMapsLinkAvailable_whenLinkExists_returnsTrue() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(mapsLink: URL(string: "https://maps.app.goo.gl/test"))
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertTrue(sut.displayData.isMapsLinkAvailable)
    }

    // BDD: "Handle empty maps link"
    func test_isMapsLinkAvailable_whenLinkNil_returnsFalse() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(mapsLink: nil)
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertFalse(sut.displayData.isMapsLinkAvailable)
    }

    // BDD: "Open website in browser"
    func test_isWebsiteAvailable_whenWebsiteExists_returnsTrue() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(website: URL(string: "https://example.com"))
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertTrue(sut.displayData.isWebsiteAvailable)
    }

    // BDD: "Handle empty website URL"
    func test_isWebsiteAvailable_whenWebsiteNil_returnsFalse() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(website: nil)
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertFalse(sut.displayData.isWebsiteAvailable)
    }

    // BDD: "Handle missing shop picture gracefully"
    func test_displayData_withNilPicture_exposesNilPicture() {
        mockUseCase.stubbedDisplayData = ShopFactory.makeDisplayData(picture: nil)
        sut = ShopDetailViewModel(shop: ShopFactory.makeShop(), useCase: mockUseCase)

        XCTAssertNil(sut.displayData.picture)
    }
}
