import SwiftUI

struct ShopDetailView: View {
    @StateObject private var viewModel: ShopDetailViewModel
    @Environment(\.dismiss) private var dismiss

    let listIndex: Int
    let listTotal: Int

    @State private var showingWebsite = false

    init(viewModel: ShopDetailViewModel, listIndex: Int, listTotal: Int) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.listIndex = listIndex
        self.listTotal = listTotal
    }

    private enum Constants {
        static let navPaddingH: CGFloat = 14
        static let navPaddingTop: CGFloat = 4
        static let bodyPaddingH: CGFloat = 28
        static let bodyPaddingTop: CGFloat = 18
        static let bodyPaddingBottom: CGFloat = 32
        static let imageAspectRatio: CGFloat = 3 / 2
        static let ruleSpacingV: CGFloat = 22
        static let defListSpacingV: CGFloat = 12
        static let defListBottomSpacing: CGFloat = 24
        static let ctaPaddingBottom: CGFloat = 32
        static let counterTracking = 0.12
        static let counterSize: Double = 10.5
    }

    var body: some View {
        VStack(spacing: 0) {
            navBar
            Rectangle().fill(Color.divider).frame(height: 1)
            ScrollView {
                detailBody
            }
        }
        .background(Color.bg)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingWebsite) {
            if let website = viewModel.displayData.website {
                SafariView(url: website)
            }
        }
    }

    // MARK: - Navigation Bar

    private var navBar: some View {
        HStack {
            IconButton(systemName: "chevron.left", accessibilityLabel: Strings.Common.back) {
                dismiss()
            }

            Spacer()

            Text(String(format: "%02d / %02d", listIndex, listTotal))
                .font(.monoCaption)
                .tracking(em: Constants.counterTracking, size: Constants.counterSize)
                .foregroundColor(.inkMuted)
                .monospacedDigit()

            Spacer()

            // Symmetry spacer — mirrors the 36pt back button
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal, Constants.navPaddingH)
        .padding(.top, Constants.navPaddingTop)
        .frame(height: 44)
    }

    // MARK: - Detail Body

    private var detailBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            rule
            ratingSection
            descriptionSection
            imageSection
            rule
            definitionList
            ctaButton
        }
        .padding(.horizontal, Constants.bodyPaddingH)
        .padding(.top, Constants.bodyPaddingTop)
        .padding(.bottom, Constants.bodyPaddingBottom)
    }

    // MARK: - Header

    private var headerSection: some View {
        Text(viewModel.displayData.name)
            .font(.detailTitle)
            .tracking(em: 0.005, size: 30)
            .foregroundColor(.ink)
            .lineSpacing(30 * 0.15)
            .padding(.top, 10)
            .padding(.bottom, 4)
    }

    // MARK: - Rule

    private var rule: some View {
        Rectangle()
            .fill(Color.divider)
            .frame(height: 1)
            .padding(.vertical, Constants.ruleSpacingV)
    }

    // MARK: - Rating

    private var ratingSection: some View {
        StarRatingView(rating: viewModel.displayData.rating, displayMode: .row)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        Text(viewModel.displayData.description)
            .font(.bodyText)
            .foregroundColor(.ink2)
            .lineSpacing(14 * 0.6)
            .padding(.top, 16)
            .padding(.bottom, 22)
    }

    // MARK: - Image

    private var imageSection: some View {
        Color.clear
            .aspectRatio(Constants.imageAspectRatio, contentMode: .fit)
            .overlay {
                ShopImageView(
                    name: viewModel.displayData.name,
                    pictureURL: viewModel.displayData.picture
                )
            }
            .clipped()
            .padding(.bottom, 4)
    }

    // MARK: - Definition List

    private var definitionList: some View {
        VStack(alignment: .leading, spacing: Constants.defListSpacingV) {
            DetailDefinitionRow(
                term: Strings.ShopDetail.address,
                value: viewModel.displayData.address,
                actionURL: viewModel.displayData.mapsLink
            )

            DetailDefinitionRow(
                term: Strings.ShopDetail.website,
                value: viewModel.displayData.displayWebsite,
                isHidden: !viewModel.displayData.isWebsiteAvailable,
                onWebsiteTap: viewModel.displayData.isWebsiteAvailable ? { showingWebsite = true } : nil
            )

            if let coord = viewModel.displayData.coordinateText {
                DetailDefinitionRow(
                    term: Strings.ShopDetail.coordinates,
                    value: coord,
                    isMono: true
                )
            }
        }
        .padding(.bottom, Constants.defListBottomSpacing)
    }

    // MARK: - Open in Maps CTA

    @ViewBuilder
    private var ctaButton: some View {
        if let mapsURL = viewModel.displayData.mapsLink {
            PrimaryButton(title: Strings.ShopDetail.openInMaps) {
                UIApplication.shared.open(mapsURL)
            }
            .padding(.top, 8)
            .padding(.bottom, Constants.ctaPaddingBottom)
        }
    }
}

// MARK: - Preview

#Preview("With photo & coordinates") {
    let shop = Shop(
        id: "preview-1",
        name: "Miyasaka Brewing Co.",
        description: "Founded in 1662, Miyasaka Brewing is one of Nagano's oldest sake breweries, producing the award-winning Masumi label in the Suwa basin.",
        picture: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Sake_bottles.jpg/640px-Sake_bottles.jpg"),
        rating: 4.5,
        address: "長野県諏訪郡富士見町落合10116-2",
        coordinate: Coordinate(latitude: 35.952, longitude: 138.263),
        googleMapsLink: URL(string: "https://maps.app.goo.gl/test"),
        website: URL(string: "https://masumi.co.jp")
    )
    ShopDetailView(
        viewModel: ShopDetailViewModel(shop: shop, useCase: ShopDetailUseCase()),
        listIndex: 3,
        listTotal: 12
    )
    .background(Color.bg)
}

#Preview("No photo · no website") {
    let shop = Shop(
        id: "preview-2",
        name: "Tamamura Honten",
        description: "A small traditional brewery in Ueda city known for its junmai daiginjo and dry-style nihonshu.",
        picture: nil,
        rating: 3.8,
        address: "長野県上田市中央4-7-33",
        coordinate: nil,
        googleMapsLink: URL(string: "https://maps.app.goo.gl/test"),
        website: nil
    )
    ShopDetailView(
        viewModel: ShopDetailViewModel(shop: shop, useCase: ShopDetailUseCase()),
        listIndex: 7,
        listTotal: 12
    )
    .background(Color.bg)
}
