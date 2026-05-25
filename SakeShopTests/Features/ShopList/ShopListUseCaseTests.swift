import XCTest
@testable import SakeShop

final class ShopListUseCaseTests: XCTestCase {
    private var sut: ShopListUseCase!
    private var mockRepository: MockShopRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockShopRepository()
        sut = ShopListUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // BDD: "Successfully load shop data from local source"
    func test_execute_callsRepositoryOnce() async throws {
        mockRepository.stubbedShops = [ShopFactory.makeShop()]

        _ = try await sut.execute()

        XCTAssertEqual(mockRepository.fetchCallCount, 1)
    }

    func test_execute_returnsRepositoryShops() async throws {
        let expected = [ShopFactory.makeShop(name: "Endo Brewery"), ShopFactory.makeShop(name: "Miyasaka")]
        mockRepository.stubbedShops = expected

        let result = try await sut.execute()

        XCTAssertEqual(result, expected)
    }

    // BDD: "Handle data loading error"
    func test_execute_propagatesRepositoryError() async {
        mockRepository.shouldThrow = AppError.dataNotFound

        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as AppError {
            guard case .dataNotFound = error else {
                XCTFail("Expected dataNotFound, got \(error)")
                return
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // BDD: "Handle malformed JSON"
    func test_execute_propagatesDecodingError() async {
        let decodingError = NSError(domain: "TestDomain", code: 0)
        mockRepository.shouldThrow = AppError.decodingFailed(decodingError)

        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as AppError {
            guard case .decodingFailed = error else {
                XCTFail("Expected decodingFailed, got \(error)")
                return
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
