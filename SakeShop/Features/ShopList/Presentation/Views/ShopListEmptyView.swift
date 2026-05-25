import SwiftUI

// MARK: - ShopListEmptyView

/// Centered empty state shown when the data source returns zero shops.
struct ShopListEmptyView: View {
    let onRefresh: () -> Void

    private enum Constants {
        static let glyphSize: CGFloat = 56
        static let titleBottomSpacing: CGFloat = 10
        static let bodyBottomSpacing: CGFloat = 24
        static let centerPaddingH: CGFloat = 36
        static let centerPaddingBottom: CGFloat = 60
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                bottleGlyph
                    .frame(width: Constants.glyphSize, height: Constants.glyphSize)
                    .foregroundColor(.inkSoft)

                Text(Strings.ShopList.emptyTitle)
                    .font(.sectionTitle)
                    .foregroundColor(.ink)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, Constants.titleBottomSpacing)

                Text(Strings.ShopList.emptyBody)
                    .font(.bodySmall)
                    .foregroundColor(.inkMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(13.5 * 0.55)
                    .padding(.bottom, Constants.bodyBottomSpacing)

                SecondaryButton(title: Strings.ShopList.refresh, action: onRefresh)
            }
            .padding(.horizontal, Constants.centerPaddingH)
            .padding(.bottom, Constants.centerPaddingBottom)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bottle Glyph

    private var bottleGlyph: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let scaleX = w / 48
            let scaleY = h / 48

            var bottle = Path()
            bottle.move(to: CGPoint(x: 16 * scaleX, y: 6 * scaleY))
            bottle.addLine(to: CGPoint(x: 32 * scaleX, y: 6 * scaleY))
            bottle.addLine(to: CGPoint(x: 32 * scaleX, y: 12 * scaleY))
            bottle.addLine(to: CGPoint(x: 29 * scaleX, y: 16 * scaleY))
            bottle.addLine(to: CGPoint(x: 29 * scaleX, y: 20 * scaleY))
            bottle.addLine(to: CGPoint(x: 34 * scaleX, y: 26 * scaleY))
            bottle.addLine(to: CGPoint(x: 34 * scaleX, y: 42 * scaleY))
            bottle.addLine(to: CGPoint(x: 14 * scaleX, y: 42 * scaleY))
            bottle.addLine(to: CGPoint(x: 14 * scaleX, y: 26 * scaleY))
            bottle.addLine(to: CGPoint(x: 19 * scaleX, y: 20 * scaleY))
            bottle.addLine(to: CGPoint(x: 19 * scaleX, y: 16 * scaleY))
            bottle.addLine(to: CGPoint(x: 16 * scaleX, y: 12 * scaleY))
            bottle.closeSubpath()

            context.stroke(bottle, with: .foreground, lineWidth: 1.2 * min(scaleX, scaleY))

            var band = Path()
            band.move(to: CGPoint(x: 19 * scaleX, y: 16 * scaleY))
            band.addLine(to: CGPoint(x: 29 * scaleX, y: 16 * scaleY))
            context.stroke(band, with: .color(.inkSoft.opacity(0.6)), lineWidth: 1.2 * min(scaleX, scaleY))
        }
    }
}

// MARK: - Preview

#Preview {
    ShopListEmptyView(onRefresh: {})
        .background(Color.bg)
}
