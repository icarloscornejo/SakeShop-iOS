import Foundation

/// Generic loader for JSON files bundled with the app.
struct JSONLoader {
    private enum Constants {
        static let fileExtension = "json"
    }

    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: Constants.fileExtension) else {
            throw AppError.dataNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw AppError.decodingFailed(error)
        } catch {
            throw AppError.unknown(error)
        }
    }
}
