import SwiftUI

/// Reusable async image with placeholder fallback.
/// Handles nil URLs and failed loads gracefully per BDD contract.
struct AsyncShopImageView: View {
    let url: URL?

    private enum Constants {
        static let placeholderIcon = "photo"
        static let cornerRadius: CGFloat = 8
    }

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    private var placeholder: some View {
        Rectangle()
            .foregroundColor(.secondary.opacity(0.2))
            .overlay(
                Image(systemName: Constants.placeholderIcon)
                    .foregroundColor(.secondary)
            )
    }
}
