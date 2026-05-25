import SwiftUI

/// Reusable async image with three distinct states:
/// - nil URL → emptyPlaceholder (no image exists for this shop)
/// - phase .empty → loading indicator (fetch in progress)
/// - phase .failure → failurePlaceholder (fetch attempted and failed)
struct AsyncShopImageView: View {
    let url: URL?

    private enum Constants {
        static let noImageIcon = "photo"
        static let failureIcon = "photo.badge.exclamationmark"
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
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.secondary.opacity(0.1))
                    case .failure:
                        failurePlaceholder
                    @unknown default:
                        failurePlaceholder
                    }
                }
            } else {
                emptyPlaceholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    private var emptyPlaceholder: some View {
        Rectangle()
            .foregroundColor(.secondary.opacity(0.2))
            .overlay(
                Image(systemName: Constants.noImageIcon)
                    .foregroundColor(.secondary)
            )
    }

    private var failurePlaceholder: some View {
        Rectangle()
            .foregroundColor(.secondary.opacity(0.2))
            .overlay(
                Image(systemName: Constants.failureIcon)
                    .foregroundColor(.secondary)
            )
    }
}
