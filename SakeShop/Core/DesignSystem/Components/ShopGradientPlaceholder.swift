import SwiftUI

// MARK: - ShopGradientPlaceholder

/// Hue-driven gradient placeholder shown when a shop has no photo or fails to load one.
/// The hue is derived deterministically from the shop name so the same shop
/// always renders the same palette across launches.
struct ShopGradientPlaceholder: View {

    enum Badge {
        case none
        case noPhoto
        case loadError
    }

    let hue: Double
    let badge: Badge

    private enum Constants {
        static let bottleWidthRatio: CGFloat = 0.38
        static let bottleAspect: CGFloat = 2.2
        static let cupWidthRatio: CGFloat = 0.14
        static let cupAspect: CGFloat = 1.4
        static let bottleOpacity: Double = 0.55
        static let cupOpacity: Double = 0.50
        static let bottleBlur: CGFloat = 1.0
        // ZStack y-offset fractions (from center)
        static let bottleYOffsetFraction: CGFloat = 0.42   // pushes bottle toward bottom
        static let cupYOffsetFraction: CGFloat = -0.16    // pushes cup toward upper-mid
        static let badgePaddingH: CGFloat = 16
        static let badgePaddingV: CGFloat = 4
        static let badgeCornerRadius: CGFloat = 2
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                mainGradient
                radialOverlays(in: geo.size)
                bottleShape(in: geo.size)
                cupShape(in: geo.size)
            }
        }
        .overlay(
            alignment: badge == .noPhoto ? .bottomLeading : .center
        ) {
            if badge != .none {
                badgeView
                    .padding(.leading, Constants.badgePaddingH)
                    .padding(.bottom, Constants.badgePaddingH)
            }
        }
    }

    // MARK: - Gradient Layers

    private var mainGradient: some View {
        LinearGradient(
            stops: [
                .init(color: paletteColor(lightness: 0.92, saturation: 0.12), location: 0),
                .init(color: paletteColor(lightness: 0.80, saturation: 0.22), location: 1),
            ],
            startPoint: UnitPoint(x: 0.1, y: 0),
            endPoint: UnitPoint(x: 0.9, y: 1)
        )
    }

    private func radialOverlays(in size: CGSize) -> some View {
        ZStack {
            RadialGradient(
                colors: [
                    paletteColor(lightness: 0.55, saturation: 0.28).opacity(0.4),
                    .clear,
                ],
                center: UnitPoint(x: 0.3, y: 1.1),
                startRadius: 0,
                endRadius: size.width * 0.6
            )
            RadialGradient(
                colors: [
                    paletteColor(lightness: 0.95, saturation: 0.08).opacity(0.5),
                    .clear,
                ],
                center: UnitPoint(x: 0.75, y: 0.25),
                startRadius: 0,
                endRadius: size.width * 0.35
            )
        }
    }

    /// Elongated sake-bottle silhouette, partially below the bottom edge.
    private func bottleShape(in size: CGSize) -> some View {
        let w = size.width * Constants.bottleWidthRatio
        let h = w * Constants.bottleAspect
        return LinearGradient(
            colors: [
                paletteColor(lightness: 0.45, saturation: 0.30),
                paletteColor(lightness: 0.30, saturation: 0.25),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: w, height: h)
        .clipShape(RoundedRectangle(cornerRadius: w * 0.35))
        .blur(radius: Constants.bottleBlur)
        .opacity(Constants.bottleOpacity)
        // In a ZStack the child's natural position is the ZStack's center.
        // Positive y-offset pushes downward.
        .offset(y: size.height * Constants.bottleYOffsetFraction)
    }

    /// Small sake-cup shape above the bottle.
    private func cupShape(in size: CGSize) -> some View {
        let w = size.width * Constants.cupWidthRatio
        let h = w * Constants.cupAspect
        return LinearGradient(
            colors: [
                paletteColor(lightness: 0.36, saturation: 0.32),
                paletteColor(lightness: 0.22, saturation: 0.26),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: w, height: h)
        .clipShape(RoundedRectangle(cornerRadius: w * 0.35))
        .opacity(Constants.cupOpacity)
        .offset(y: size.height * Constants.cupYOffsetFraction)
    }

    // MARK: - Badge

    private var badgeView: some View {
        Text(badge == .noPhoto ? Strings.Common.noPhoto : Strings.Common.imageLoadError)
            .font(.monoSmall)
            .tracking(em: 0.12, size: 9)
            .textCase(.uppercase)
            .foregroundColor(Color.white.opacity(0.92))
            .padding(.horizontal, Constants.badgePaddingH)
            .padding(.vertical, Constants.badgePaddingV)
            .background(
                Color(red: 20/255, green: 15/255, blue: 10/255, opacity: 0.45)
                    .background(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.badgeCornerRadius))
    }

    // MARK: - Palette Helper

    /// Approximates OKLCH values from the spec in SwiftUI's HSB color space.
    private func paletteColor(lightness: Double, saturation: Double) -> Color {
        Color(hue: hue / 360.0, saturation: saturation, brightness: lightness)
    }
}

// MARK: - Preview

#Preview("No photo") {
    Color.clear
        .aspectRatio(CGSize(width: 3, height: 2), contentMode: .fit)
        .overlay { ShopGradientPlaceholder(hue: 30, badge: .noPhoto) }
        .clipped()
        .padding(24)
        .background(Color.bg)
}

#Preview("Error loading") {
    Color.clear
        .aspectRatio(CGSize(width: 3, height: 2), contentMode: .fit)
        .overlay { ShopGradientPlaceholder(hue: 200, badge: .loadError) }
        .clipped()
        .padding(24)
        .background(Color.bg)
}

#Preview("No badge · hue variation") {
    VStack(spacing: 12) {
        ForEach([0.0, 60.0, 180.0, 300.0], id: \.self) { hue in
            Color.clear
                .aspectRatio(CGSize(width: 4, height: 1), contentMode: .fit)
                .overlay { ShopGradientPlaceholder(hue: hue, badge: .none) }
                .clipped()
        }
    }
    .padding(24)
    .background(Color.bg)
}
