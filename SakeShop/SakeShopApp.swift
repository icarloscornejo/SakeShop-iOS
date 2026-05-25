import SwiftUI

@main
struct SakeShopApp: App {
    @StateObject private var container = DIContainer()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ShopListView(viewModel: container.makeShopListViewModel())
                .environmentObject(container)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .background(Color.bg)
        }
    }
}
