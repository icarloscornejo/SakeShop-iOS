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

    // BDD: "Open in Apple Maps when coordinates are available"
    // Given a shop with coordinates
    // When the use case is executed
    // Then mapsLink is an Apple Maps URL (maps:// scheme) with ll and q params
    func test_execute_withCoordinates_buildAppleMapsURL() {
        let coord = Coordinate(latitude: 36.6959, longitude: 138.2113)
        let shop = ShopFactory.makeShop(name: "Miyasaka Brewing", coordinate: coord, googleMapsLink: nil)

        let result = sut.execute(shop: shop)

        guard let url = result.mapsLink,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return XCTFail("Expected a non-nil Apple Maps URL")
        }
        XCTAssertEqual(components.scheme, "maps")
        let ll = components.queryItems?.first(where: { $0.name == "ll" })?.value
        XCTAssertEqual(ll, "36.6959,138.2113")
        let q = components.queryItems?.first(where: { $0.name == "q" })?.value
        XCTAssertEqual(q, "Miyasaka Brewing")
    }

    // BDD: "Fall back to Google Maps when coordinates are absent"
    // Given a shop without coordinates but with a Google Maps link
    // When the use case is executed
    // Then mapsLink is the Google Maps URL
    func test_execute_withoutCoordinates_usesGoogleMapsLinkAsFallback() {
        let googleURL = URL(string: "https://maps.app.goo.gl/test")!
        let shop = ShopFactory.makeShop(coordinate: nil, googleMapsLink: googleURL)

        let result = sut.execute(shop: shop)

        XCTAssertEqual(result.mapsLink, googleURL)
    }

    // BDD: "Apple Maps takes priority over Google Maps link"
    // Given a shop with both coordinates and a Google Maps link
    // When the use case is executed
    // Then mapsLink uses the Apple Maps scheme (coordinates take priority)
    func test_execute_withCoordinatesAndGoogleLink_prefersAppleMaps() {
        let coord = Coordinate(latitude: 36.6959, longitude: 138.2113)
        let shop = ShopFactory.makeShop(
            coordinate: coord,
            googleMapsLink: URL(string: "https://maps.app.goo.gl/test")
        )

        let result = sut.execute(shop: shop)

        XCTAssertEqual(result.mapsLink?.scheme, "maps")
    }

    // BDD: "Hide Open in Maps button when no location data is available"
    // Given a shop with no coordinates and no Google Maps link
    // When the use case is executed
    // Then mapsLink is nil and isMapsLinkAvailable is false
    func test_execute_withNoLocationData_mapsLinkIsNil() {
        let shop = ShopFactory.makeShop(coordinate: nil, googleMapsLink: nil)

        let result = sut.execute(shop: shop)

        XCTAssertNil(result.mapsLink)
        XCTAssertFalse(result.isMapsLinkAvailable)
    }

    // BDD: "Handle partial data with null fields"
    func test_execute_withAllNilOptionals_doesNotCrash() {
        let shop = ShopFactory.makeShop(picture: nil, coordinate: nil, googleMapsLink: nil, website: nil)

        let result = sut.execute(shop: shop)

        XCTAssertNil(result.picture)
        XCTAssertNil(result.mapsLink)
        XCTAssertNil(result.website)
        XCTAssertFalse(result.isMapsLinkAvailable)
        XCTAssertFalse(result.isWebsiteAvailable)
    }
}
