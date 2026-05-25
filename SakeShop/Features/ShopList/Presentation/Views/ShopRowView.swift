import SwiftUI

// MARK: - ShopRowView

/// One row in the shop index list.
/// Layout: numbered index column (left) + name/sub-row body (right).
/// No thumbnail — the design is text-first ("printed index" aesthetic).
struct ShopRowView: View {
    let shop: Shop
    let index: Int   // 1-based display number

    private enum Constants {
        static let rowPaddingV: CGFloat = 14
        static let rowPaddingH: CGFloat = 24
        static let columnGap: CGFloat = 18
        static let subRowTopSpacing: CGFloat = 4
        static let indexMinWidth: CGFloat = 22
        static let ratingChipGap: CGFloat = 5
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Constants.columnGap) {
            indexLabel
            bodyColumn
        }
        .padding(.horizontal, Constants.rowPaddingH)
        .padding(.vertical, Constants.rowPaddingV)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Index column

    private var indexLabel: some View {
        Text(String(format: "%02d", index))
            .font(.monoIndex)
            .foregroundColor(.inkSoft)
            .monospacedDigit()
            .frame(minWidth: Constants.indexMinWidth, alignment: .leading)
    }

    // MARK: - Body column

    private var bodyColumn: some View {
        VStack(alignment: .leading, spacing: Constants.subRowTopSpacing) {
            nameRow
            addressLabel
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var nameRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(shop.name)
                .font(.rowName)
                .tracking(em: 0.005, size: 17)
                .foregroundColor(.ink)
                .lineLimit(1)

            Spacer(minLength: Constants.ratingChipGap)

            StarRatingView(rating: shop.rating, displayMode: .inline)
        }
    }

    private var addressLabel: some View {
        Text(shop.address)
            .font(.listSub)
            .foregroundColor(.inkMuted)
            .lineLimit(1)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        ShopRowView(
            shop: Shop(
                id: "1", name: "Miyasaka Brewing Co.", description: "",
                picture: nil, rating: 4.5,
                address: "長野県諏訪郡富士見町落合10116",
                coordinate: nil, googleMapsLink: nil, website: nil
            ),
            index: 1
        )
        Divider()
        ShopRowView(
            shop: Shop(
                id: "2", name: "Tamamura Honten", description: "",
                picture: nil, rating: 3.8,
                address: "長野県上田市中央4-7-33",
                coordinate: nil, googleMapsLink: nil, website: nil
            ),
            index: 2
        )
        Divider()
        ShopRowView(
            shop: Shop(
                id: "3", name: "Daisekkei Sake Brewery — Long Name Example", description: "",
                picture: nil, rating: 1.0,
                address: "長野県大町市大町2717",
                coordinate: nil, googleMapsLink: nil, website: nil
            ),
            index: 3
        )
    }
    .background(Color.bg)
}
