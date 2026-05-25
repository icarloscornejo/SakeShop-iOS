import SwiftUI

@main
struct SakeShopApp: App {
    private let container = DIContainer()

    var body: some Scene {
        WindowGroup {
            ShopListView(viewModel: container.makeShopListViewModel())
                .environmentObject(container)
        }
    }
}
