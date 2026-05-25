import SwiftUI

struct ShopDetailView: View {
    @StateObject private var viewModel: ShopDetailViewModel

    init(viewModel: ShopDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private enum Constants {
        static let imageHeight: CGFloat = 260
        static let sectionSpacing: CGFloat = 16
        static let contentPadding: CGFloat = 16
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                AsyncShopImageView(url: viewModel.displayData.picture)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.imageHeight)

                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    Text(viewModel.displayData.name)
                        .font(.title2)
                        .bold()

                    StarRatingView(rating: viewModel.displayData.rating)

                    Text(viewModel.displayData.description)
                        .font(.body)
                        .foregroundColor(.secondary)

                    addressView

                    websiteButton
                }
                .padding(.horizontal, Constants.contentPadding)
                .padding(.bottom, Constants.contentPadding)
            }
        }
        .navigationTitle(viewModel.displayData.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Tappable only when a valid maps link exists — per BDD contract.
    @ViewBuilder
    private var addressView: some View {
        if viewModel.displayData.isMapsLinkAvailable, let mapsLink = viewModel.displayData.mapsLink {
            Link(destination: mapsLink) {
                Text(viewModel.displayData.address)
                    .font(.subheadline)
                    .underline()
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.leading)
            }
        } else {
            Text(viewModel.displayData.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
    }

    /// Hidden when no valid website URL exists — per BDD contract.
    @ViewBuilder
    private var websiteButton: some View {
        if viewModel.displayData.isWebsiteAvailable, let website = viewModel.displayData.website {
            Link(Strings.ShopDetail.visitWebsite, destination: website)
                .buttonStyle(.borderedProminent)
        }
    }
}
