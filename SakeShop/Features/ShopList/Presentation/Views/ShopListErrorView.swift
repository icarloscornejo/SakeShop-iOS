import SwiftUI

// MARK: - ShopListErrorView

/// Centered error state with a circle-exclamation icon, title, body, and an accent "Retry" button.
struct ShopListErrorView: View {
    let onRetry: () -> Void

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
                errorGlyph
                    .frame(width: Constants.glyphSize, height: Constants.glyphSize)
                    .foregroundColor(.accent)

                Text(Strings.ShopList.errorTitle)
                    .font(.sectionTitle)
                    .foregroundColor(.ink)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, Constants.titleBottomSpacing)

                Text(Strings.ShopList.errorBody)
                    .font(.bodySmall)
                    .foregroundColor(.inkMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(13.5 * 0.55)
                    .padding(.bottom, Constants.bodyBottomSpacing)

                ErrorPrimaryButton(title: Strings.ShopList.retry, action: onRetry)
            }
            .padding(.horizontal, Constants.centerPaddingH)
            .padding(.bottom, Constants.centerPaddingBottom)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityID.ShopList.errorView)
    }

    // MARK: - Error Glyph

    private var errorGlyph: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r  = min(cx, cy) - 2

            let circle = Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
            context.stroke(circle, with: .foreground, lineWidth: 1.4)

            var line = Path()
            line.move(to: CGPoint(x: cx, y: cy - r * 0.55))
            line.addLine(to: CGPoint(x: cx, y: cy + r * 0.10))
            context.stroke(line, with: .foreground, style: StrokeStyle(lineWidth: 1.4, lineCap: .round))

            let dotR: CGFloat = 1.2
            let dot = Path(ellipseIn: CGRect(x: cx - dotR, y: cy + r * 0.22, width: dotR * 2, height: dotR * 2))
            context.fill(dot, with: .foreground)
        }
    }
}

// MARK: - Preview

#Preview {
    ShopListErrorView(onRetry: {})
        .background(Color.bg)
}
