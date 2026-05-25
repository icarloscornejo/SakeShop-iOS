import SwiftUI

struct ShopListView: View {
    @StateObject private var viewModel: ShopListViewModel
    @EnvironmentObject private var container: DIContainer

    init(viewModel: ShopListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(Strings.ShopList.navigationTitle)
                .task { await viewModel.loadShops() }
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailView(viewModel: container.makeShopDetailViewModel(shop: shop))
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let shops):
            List(shops) { shop in
                NavigationLink(value: shop) {
                    ShopRowView(shop: shop)
                }
            }
        case .empty:
            Text(Strings.ShopList.emptyState)
                .foregroundColor(.secondary)
        case .error(let message):
            VStack(spacing: 16) {
                Text(message)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button(Strings.ShopList.retry) {
                    Task { await viewModel.retry() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
