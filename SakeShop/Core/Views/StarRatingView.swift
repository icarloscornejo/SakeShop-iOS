import SwiftUI

/// Reusable star rating display. Used in ShopList and ShopDetail.
struct StarRatingView: View {
    let rating: Double

    private enum Constants {
        static let maxRating = 5
        static let starSpacing: CGFloat = 2
        static let starColor = Color.yellow
        static let filledStarOffset = 0.75
        static let halfStarOffset = 0.25
        static let filledStar = "star.fill"
        static let halfStar = "star.leadinghalf.filled"
        static let emptyStar = "star"
        static let ratingFormat = "%.1f"
    }

    var body: some View {
        HStack(spacing: Constants.starSpacing) {
            ForEach(0..<Constants.maxRating, id: \.self) { index in
                starImage(for: index)
                    .foregroundColor(Constants.starColor)
            }
            Text(String(format: Constants.ratingFormat, rating))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func starImage(for index: Int) -> Image {
        let filled = Double(index) + Constants.filledStarOffset
        let half = Double(index) + Constants.halfStarOffset
        if rating >= filled {
            return Image(systemName: Constants.filledStar)
        } else if rating >= half {
            return Image(systemName: Constants.halfStar)
        } else {
            return Image(systemName: Constants.emptyStar)
        }
    }
}
