import XCTest
@testable import SakeShop

final class ShopDTOTests: XCTestCase {
    private func makeDTO(
        name: String = "Test Shop",
        description: String = "Test description",
        picture: String? = "https://example.com/image.jpg",
        rating: Double = 4.0,
        address: String = "Test Address",
        coordinates: [Double] = [36.0, 138.0],
        googleMapsLink: String? = "https://maps.app.goo.gl/test",
        website: String? = "https://example.com"
    ) -> ShopDTO {
        ShopDTO(
            name: name,
            description: description,
            picture: picture,
            rating: rating,
            address: address,
            coordinates: coordinates,
            googleMapsLink: googleMapsLink,
            website: website
        )
    }

    // MARK: - Field mapping

    // BDD: "Successfully load shop data from local source"
    func test_toDomain_mapsAllScalarFieldsCorrectly() {
        let dto = makeDTO(name: "Endo Brewery", description: "Historic brewery", rating: 4.5, address: "Nagano")

        let shop = dto.toDomain()

        XCTAssertEqual(shop.name, "Endo Brewery")
        XCTAssertEqual(shop.description, "Historic brewery")
        XCTAssertEqual(shop.rating, 4.5)
        XCTAssertEqual(shop.address, "Nagano")
    }

    // BDD: "Handle partial data with null fields"
    func test_toDomain_withAllNilOptionals_producesNilFields() {
        let dto = makeDTO(picture: nil, googleMapsLink: nil, website: nil)

        let shop = dto.toDomain()

        XCTAssertNil(shop.picture)
        XCTAssertNil(shop.googleMapsLink)
        XCTAssertNil(shop.website)
    }

    // MARK: - Deterministic ID (T2)

    func test_toDomain_sameInput_producesSameId() {
        let dto = makeDTO(name: "Miyasaka", address: "Suwa")

        XCTAssertEqual(dto.toDomain().id, dto.toDomain().id)
    }

    func test_toDomain_differentName_producesDifferentId() {
        let a = makeDTO(name: "Shop A", address: "Same Address").toDomain()
        let b = makeDTO(name: "Shop B", address: "Same Address").toDomain()

        XCTAssertNotEqual(a.id, b.id)
    }

    func test_toDomain_differentAddress_producesDifferentId() {
        let a = makeDTO(name: "Same Name", address: "Address A").toDomain()
        let b = makeDTO(name: "Same Name", address: "Address B").toDomain()

        XCTAssertNotEqual(a.id, b.id)
    }

    // MARK: - URL parsing

    // BDD: "Handle empty maps link" / "Handle empty website URL"
    func test_toDomain_withInvalidPictureURL_producesNilPicture() {
        let dto = makeDTO(picture: "")

        XCTAssertNil(dto.toDomain().picture)
    }

    func test_toDomain_withInvalidMapsLink_producesNilGoogleMapsLink() {
        let dto = makeDTO(googleMapsLink: "")

        XCTAssertNil(dto.toDomain().googleMapsLink)
    }

    func test_toDomain_withValidURLs_parsesCorrectly() {
        let dto = makeDTO(
            picture: "https://example.com/img.jpg",
            googleMapsLink: "https://maps.app.goo.gl/test",
            website: "https://example.com"
        )
        let shop = dto.toDomain()

        XCTAssertNotNil(shop.picture)
        XCTAssertNotNil(shop.googleMapsLink)
        XCTAssertNotNil(shop.website)
    }

    // MARK: - Coordinate mapping (T5)

    // BDD: "Handle partial data with null fields"
    func test_toDomain_withValidCoordinates_producesCoordinate() {
        let dto = makeDTO(coordinates: [36.64, 138.18])

        let coord = dto.toDomain().coordinate
        XCTAssertNotNil(coord)
        XCTAssertEqual(coord?.latitude, 36.64)
        XCTAssertEqual(coord?.longitude, 138.18)
    }

    func test_toDomain_withEmptyCoordinates_producesNilCoordinate() {
        let dto = makeDTO(coordinates: [])

        XCTAssertNil(dto.toDomain().coordinate)
    }

    func test_toDomain_withSingleCoordinate_producesNilCoordinate() {
        let dto = makeDTO(coordinates: [36.64])

        XCTAssertNil(dto.toDomain().coordinate)
    }

    func test_toDomain_withOutOfRangeCoordinates_producesNilCoordinate() {
        let dto = makeDTO(coordinates: [999.0, 999.0])

        XCTAssertNil(dto.toDomain().coordinate)
    }
}
