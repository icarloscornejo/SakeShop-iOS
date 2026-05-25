import SwiftUI

struct ShopListView: View {
    @StateObject private var viewModel: ShopListViewModel
    @EnvironmentObject private var container: DIContainer

    init(viewModel: ShopListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ListHeaderView(actionsEnabled: viewModel.state.isLoaded)
                Rectangle().fill(Color.divider).frame(height: 1)
                content
            }
            .background(Color.bg)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: ShopNavigation.self) { nav in
                ShopDetailView(
                    viewModel: container.makeShopDetailViewModel(shop: nav.shop),
                    listIndex: nav.index,
                    listTotal: nav.total
                )
            }
        }
        .task { await viewModel.loadShops() }
    }

    // MARK: - State Router

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ScrollView {
                ShopListLoadingView()
            }

        case .loaded(let shops):
            loadedContent(shops: shops)

        case .empty:
            ShopListEmptyView {
                Task { await viewModel.retry() }
            }

        case .error:
            ShopListErrorView {
                Task { await viewModel.retry() }
            }
        }
    }

    // MARK: - Loaded content

    private func loadedContent(shops: [Shop]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                titleBlock(count: shops.count)
                Rectangle().fill(Color.divider).frame(height: 1)
                Spacer().frame(height: 4)
                shopRows(shops: shops)
                endOfListLabel
            }
        }
        .refreshable {
            await viewModel.retry()
        }
    }

    // MARK: - Title block

    private func titleBlock(count: Int) -> some View {
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

            HStack(spacing: 8) {
                Text(String(format: Strings.ShopList.entriesFormat, count))
                Text("·").foregroundColor(.inkSoft)
                Text(Strings.ShopList.updatedDate)
            }
            .font(.monoCaption)
            .tracking(em: 0.04, size: 10.5)
            .foregroundColor(.inkMuted)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Shop rows

    @ViewBuilder
    private func shopRows(shops: [Shop]) -> some View {
        ForEach(Array(shops.enumerated()), id: \.element.id) { offset, shop in
            NavigationLink(value: ShopNavigation(shop: shop, index: offset + 1, total: shops.count)) {
                ShopRowView(shop: shop, index: offset + 1)
            }
            .buttonStyle(.plain)
            Rectangle().fill(Color.divider).frame(height: 1)
        }
    }

    // MARK: - End of list

    private var endOfListLabel: some View {
        Text(Strings.ShopList.endOfList)
            .font(.eyebrow)
            .tracking(em: 0.15, size: 10)
            .textCase(.uppercase)
            .foregroundColor(.inkSoft)
            .padding(.vertical, 22)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - ViewState helpers

private extension ShopListViewModel.ViewState {
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
}

// MARK: - Preview

#Preview {
    let container = DIContainer()
    ShopListView(viewModel: container.makeShopListViewModel())
        .environmentObject(container)
        .environmentObject(ThemeManager())
}
