import SwiftUI

// MARK: - ShopListLoadingView

/// Skeleton loading state: numbered rows with shimmering placeholder bars.
/// Numbers (01–07) are always visible to give the page structure while data loads.
struct ShopListLoadingView: View {
    private enum Constants {
        static let skeletonRowCount = 7
        static let nameWidthRatios: [CGFloat] = [0.68, 0.78, 0.60, 0.72, 0.82, 0.55, 0.70]
        static let subWidthRatios: [CGFloat] = [0.44, 0.52, 0.38, 0.48]
        static let chipWidth: CGFloat = 32
        static let chipHeight: CGFloat = 10
        static let subHeight: CGFloat = 9
    }

    var body: some View {
        VStack(spacing: 0) {
            titleBlock
            rowsBlock
        }
    }

    // MARK: - Title block

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Strings.ShopList.anIndexOf)
                .font(.eyebrow)
                .tracking(em: 0.18, size: 10)
                .textCase(.uppercase)
                .foregroundColor(.inkMuted)

            Text(Strings.ShopList.listTitle)
                .font(.display)
                .tracking(em: -0.01, size: 36)
                .foregroundColor(.ink)
                .lineSpacing(36 * 0.05)
                .padding(.top, 12)
                .padding(.bottom, 14)

            SkeletonBar(width: 90, height: 10)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.divider).frame(height: 1)
        }
    }

    // MARK: - Rows

    private var rowsBlock: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<Constants.skeletonRowCount, id: \.self) { index in
                skeletonRow(index: index)
                Rectangle().fill(Color.divider).frame(height: 1)
            }
        }
        .padding(.top, 4)
    }

    private func skeletonRow(index: Int) -> some View {
        HStack(alignment: .top, spacing: 18) {
            Text(String(format: "%02d", index + 1))
                .font(.monoIndex)
                .foregroundColor(.inkSoft)
                .monospacedDigit()
                .frame(minWidth: 22, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    SkeletonBar(
                        widthRatio: Constants.nameWidthRatios[index % 7],
                        height: 14
                    )
                    Spacer()
                    SkeletonBar(width: Constants.chipWidth, height: Constants.chipHeight)
                }
                SkeletonBar(
                    widthRatio: Constants.subWidthRatios[index % 4],
                    height: Constants.subHeight
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }
}

// MARK: - SkeletonBar

private struct SkeletonBar: View {
    var width: CGFloat? = nil
    var widthRatio: CGFloat? = nil
    var height: CGFloat

    @State private var phase: CGFloat = 0

    private enum Constants {
        static let duration: Double = 1.6
    }

    var body: some View {
        GeometryReader { geo in
            let w = width ?? (widthRatio.map { $0 * geo.size.width } ?? geo.size.width)
            shimmer
                .frame(width: w, height: height)
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.linear(duration: Constants.duration).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }

    private var shimmer: some View {
        LinearGradient(
            stops: [
                .init(color: Color.surface2, location: 0),
                .init(color: Color.divider,  location: 0.5),
                .init(color: Color.surface2, location: 1),
            ],
            startPoint: UnitPoint(x: -1 + phase * 3, y: 0),
            endPoint:   UnitPoint(x:  0 + phase * 3, y: 0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        ShopListLoadingView()
    }
    .background(Color.bg)
}
