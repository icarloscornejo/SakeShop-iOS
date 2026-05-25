import XCTest
@testable import SakeShop

final class CoordinateTests: XCTestCase {

    // MARK: - Valid construction (direct init)

    func test_init_withValidValues_setsLatitudeAndLongitude() {
        let coord = Coordinate(latitude: 36.64, longitude: 138.18)

        XCTAssertEqual(coord.latitude, 36.64)
        XCTAssertEqual(coord.longitude, 138.18)
    }

    // MARK: - Failable init from array

    // BDD: "Handle partial data with null fields"
    func test_initFromArray_withValidTwoElementArray_succeeds() {
        let coord = Coordinate(from: [36.64, 138.18])

        XCTAssertNotNil(coord)
        XCTAssertEqual(coord?.latitude, 36.64)
        XCTAssertEqual(coord?.longitude, 138.18)
    }

    func test_initFromArray_withEmptyArray_returnsNil() {
        XCTAssertNil(Coordinate(from: []))
    }

    func test_initFromArray_withOneElement_returnsNil() {
        XCTAssertNil(Coordinate(from: [36.64]))
    }

    func test_initFromArray_withThreeElements_returnsNil() {
        XCTAssertNil(Coordinate(from: [36.64, 138.18, 0.0]))
    }

    // MARK: - Latitude boundary validation

    func test_initFromArray_withLatitudeAtUpperBound_succeeds() {
        XCTAssertNotNil(Coordinate(from: [90.0, 0.0]))
    }

    func test_initFromArray_withLatitudeAtLowerBound_succeeds() {
        XCTAssertNotNil(Coordinate(from: [-90.0, 0.0]))
    }

    func test_initFromArray_withLatitudeAboveUpperBound_returnsNil() {
        XCTAssertNil(Coordinate(from: [90.1, 0.0]))
    }

    func test_initFromArray_withLatitudeBelowLowerBound_returnsNil() {
        XCTAssertNil(Coordinate(from: [-90.1, 0.0]))
    }

    // MARK: - Longitude boundary validation

    func test_initFromArray_withLongitudeAtUpperBound_succeeds() {
        XCTAssertNotNil(Coordinate(from: [0.0, 180.0]))
    }

    func test_initFromArray_withLongitudeAtLowerBound_succeeds() {
        XCTAssertNotNil(Coordinate(from: [0.0, -180.0]))
    }

    func test_initFromArray_withLongitudeAboveUpperBound_returnsNil() {
        XCTAssertNil(Coordinate(from: [0.0, 180.1]))
    }

    func test_initFromArray_withLongitudeBelowLowerBound_returnsNil() {
        XCTAssertNil(Coordinate(from: [0.0, -180.1]))
    }
}
