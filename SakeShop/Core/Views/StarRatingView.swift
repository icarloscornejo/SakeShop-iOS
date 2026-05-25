import SwiftUI

// MARK: - StarRatingView

/// Renders 5 stars with continuous partial fill via a per-star mask.
/// Supports two display modes:
///   - `inline`: single filled star + numeric label (list row rating chip)
///   - `row`: full 5-star row + "X.X out of 5" label (detail screen)
struct StarRatingView: View {
    let rating: Double

    enum DisplayMode {
        case inline   // 1 star + number — used in the list row chip
        case row      // 5 stars + "X.X out of 5" — used on the detail screen
    }

    var displayMode: DisplayMode = .row

    private enum Constants {
        static let maxStars: Int = 5
        static let starSpacing: CGFloat = 2
        static let listStarSize: CGFloat = 10
        static let detailStarSize: CGFloat = 14
        static let ratingFormat: String = "%.1f"
    }

    var body: some View {
        switch displayMode {
        case .inline:
            inlineView
        case .row:
            rowView
        }
    }

    // MARK: - Inline (list chip)

    private var inlineView: some View {
        HStack(spacing: Constants.starSpacing) {
            Text(String(format: Constants.ratingFormat, rating))
                .font(.monoIndex)
                .foregroundColor(.ink)
                .monospacedDigit()
            PartialStar(fill: min(1, max(0, rating)))
                .frame(width: Constants.listStarSize, height: Constants.listStarSize)
                .foregroundColor(.accent)
        }
    }

    // MARK: - Row (detail screen)

    private var rowView: some View {
        HStack(spacing: 12) {
            starsRow
            HStack(spacing: 6) {
                Text(String(format: Constants.ratingFormat, rating))
                    .font(.monoIndex)
                    .fontWeight(.bold)
                    .foregroundColor(.ink)
                    .monospacedDigit()
                Text("out of 5")
                    .font(.monoIndex)
                    .foregroundColor(.inkMuted)
            }
        }
    }

    private var starsRow: some View {
        HStack(spacing: Constants.starSpacing) {
            ForEach(0..<Constants.maxStars, id: \.self) { index in
                let fill = min(1.0, max(0.0, rating - Double(index)))
                PartialStar(fill: fill)
                    .frame(width: Constants.detailStarSize, height: Constants.detailStarSize)
                    .foregroundColor(.accent)
            }
        }
    }
}

// MARK: - PartialStar

/// A single star that fills from left to right proportionally to `fill` (0…1).
/// Uses ZStack: outlined star (ghost) beneath a clipped filled star.
private struct PartialStar: View {
    let fill: Double   // 0 = empty, 1 = fully filled, 0.6 = 60% filled

    var body: some View {
        ZStack {
            // Ghost outline (25% opacity)
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .opacity(0.25)
            // Filled layer masked to fill%
            GeometryReader { geo in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: geo.size.width * fill)
                    }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        StarRatingView(rating: 4.5, displayMode: .row)
        StarRatingView(rating: 3.0, displayMode: .row)
        StarRatingView(rating: 1.7, displayMode: .row)
        Divider()
        HStack(spacing: 16) {
            StarRatingView(rating: 4.5, displayMode: .inline)
            StarRatingView(rating: 3.0, displayMode: .inline)
            StarRatingView(rating: 1.7, displayMode: .inline)
        }
    }
    .padding(24)
    .background(Color.bg)
}
