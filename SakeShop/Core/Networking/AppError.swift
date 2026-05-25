import Foundation

enum AppError: Error, LocalizedError {
    case dataNotFound
    case decodingFailed(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return Strings.Error.dataNotFound
        case .decodingFailed:
            return Strings.Error.decodingFailed
        case .unknown:
            return Strings.Error.unknown
        }
    }
}
