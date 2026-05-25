import Foundation
import CryptoKit

/// Decodable model mapping directly to the JSON structure.
struct ShopDTO: Decodable {
    let name: String
    let description: String
    let picture: String?
    let rating: Double
    let address: String
    let coordinates: [Double]
    let googleMapsLink: String?
    let website: String?

    private enum Constants {
        static let idHashFormat = "%02x"
        static let idSeparator = "|"
    }

    enum CodingKeys: String, CodingKey {
        case name, description, picture, rating, address, coordinates, website
        case googleMapsLink = "google_maps_link"
    }

    private func stableId() -> String {
        let input = "\(name)\(Constants.idSeparator)\(address)"
        let digest = SHA256.hash(data: Data(input.utf8))
        return digest.compactMap { String(format: Constants.idHashFormat, $0) }.joined()
    }

    func toDomain() -> Shop {
        Shop(
            id: stableId(),
            name: name,
            description: description,
            picture: picture.flatMap { URL(string: $0) },
            rating: rating,
            address: address,
            coordinate: Coordinate(from: coordinates),
            googleMapsLink: googleMapsLink.flatMap { URL(string: $0) },
            website: website.flatMap { URL(string: $0) }
        )
    }
}
