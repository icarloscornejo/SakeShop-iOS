import SwiftUI

/// Reusable star rating display. Used in ShopList and ShopDetail.
struct StarRatingView: View {
    let rating: Double

    private enum Constants {
        static let maxRating = 5
        static let filledStar = "star.fill"
        static let halfStar = "star.leadinghalf.filled"
        static let emptyStar = "star"
        static let ratingFormat = "%.1f"
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<Constants.maxRating, id: \.self) { index in
                starImage(for: index)
                    .foregroundColor(.yellow)
            }
            Text(String(format: Constants.ratingFormat, rating))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func starImage(for index: Int) -> Image {
        let filled = Double(index) + 0.75
        let half = Double(index) + 0.25
        if rating >= filled {
            return Image(systemName: Constants.filledStar)
        } else if rating >= half {
            return Image(systemName: Constants.halfStar)
        } else {
            return Image(systemName: Constants.emptyStar)
        }
    }
}
