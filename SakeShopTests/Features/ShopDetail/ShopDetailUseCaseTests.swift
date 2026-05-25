import XCTest
@testable import SakeShop

final class ShopDetailUseCaseTests: XCTestCase {
    private var sut: ShopDetailUseCase!

    override func setUp() {
        super.setUp()
        sut = ShopDetailUseCase()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // BDD: "Display shop information"
    func test_execute_mapsAllFieldsToDisplayData() {
        let shop = ShopFactory.makeShop(name: "Tamamura Honten", description: "Sake and beer", rating: 4.6)

        let result = sut.execute(shop: shop)

        XCTAssertEqual(result.name, "Tamamura Honten")
        XCTAssertEqual(result.description, "Sake and beer")
        XCTAssertEqual(result.rating, 4.6)
    }

    // BDD: "Handle partial data with null fields"
    func test_execute_withAllNilOptionals_doesNotCrash() {
        let shop = ShopFactory.makeShop(picture: nil, googleMapsLink: nil, website: nil)

        let result = sut.execute(shop: shop)

        XCTAssertNil(result.picture)
        XCTAssertNil(result.mapsLink)
        XCTAssertNil(result.website)
        XCTAssertFalse(result.isMapsLinkAvailable)
        XCTAssertFalse(result.isWebsiteAvailable)
    }

    // BDD: "Handle empty maps link" / "Handle empty website URL"
    func test_execute_withValidURLs_setsAvailabilityTrue() {
        let shop = ShopFactory.makeShop(
            googleMapsLink: URL(string: "https://maps.app.goo.gl/test"),
            website: URL(string: "https://example.com")
        )

        let result = sut.execute(shop: shop)

        XCTAssertTrue(result.isMapsLinkAvailable)
        XCTAssertTrue(result.isWebsiteAvailable)
    }
}
