import SwiftUI

// MARK: - ShopImageView

/// Composite image component with three distinct visual states:
///
/// - `pictureURL == nil`  → gradient placeholder + "No photo" badge (shown immediately)
/// - Loading             → neutral gray rectangle + centered spinner
/// - Success             → real shop photo (crossfades in)
/// - Failure             → gradient placeholder + "Error loading" badge
///
/// Hue is derived deterministically from the shop name so the same shop
/// always produces the same palette: `abs(name.hashValue) % 360`.
struct ShopImageView: View {
    let name: String
    let pictureURL: URL?

    private enum Constants {
        static let cornerRadius: CGFloat = 2
        static let fadeDuration: Double = 0.3
    }

    private var hue: Double {
        Double(abs(name.hashValue) % 360)
    }

    var body: some View {
        Group {
            if let url = pictureURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.opacity.animation(.easeInOut(duration: Constants.fadeDuration)))
                    case .empty:
                        loadingState
                    case .failure:
                        ShopGradientPlaceholder(hue: hue, badge: .loadError)
                    @unknown default:
                        loadingState
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ShopGradientPlaceholder(hue: hue, badge: .noPhoto)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    // MARK: - Loading state

    private var loadingState: some View {
        ZStack {
            Color.surface2
            ProgressView()
                .tint(.inkSoft)
        }
    }
}

// MARK: - Preview

#Preview("No photo") {
    Color.clear
        .aspectRatio(CGSize(width: 3, height: 2), contentMode: .fit)
        .overlay { ShopImageView(name: "Miyasaka Brewing", pictureURL: nil) }
        .clipped()
        .padding(24)
        .background(Color.bg)
}

#Preview("Loading / with URL") {
    Color.clear
        .aspectRatio(CGSize(width: 3, height: 2), contentMode: .fit)
        .overlay {
            ShopImageView(
                name: "Tamamura Honten",
                pictureURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Sake_bottles.jpg/640px-Sake_bottles.jpg")
            )
        }
        .clipped()
        .padding(24)
        .background(Color.bg)
}
