import SwiftUI

/// List row displaying a shop's name, address, and rating.
/// Image is present in the hierarchy but hidden — ready for future list image support.
struct ShopRowView: View {
    let shop: Shop

    private enum Constants {
        static let imageSize: CGFloat = 0
        static let verticalSpacing: CGFloat = 4
    }

    var body: some View {
        HStack(alignment: .top) {
            // Future: reveal by removing .hidden() when list images are enabled
            AsyncShopImageView(url: shop.picture)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .hidden()

            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                Text(shop.name)
                    .font(.headline)
                Text(shop.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                StarRatingView(rating: shop.rating)
            }
        }
    }
}
