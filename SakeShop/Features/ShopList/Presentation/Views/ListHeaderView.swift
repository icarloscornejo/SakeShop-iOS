import SwiftUI

// MARK: - ListHeaderView

/// Top header shared by all list states (loading, loaded, empty, error).
/// Contains the brand mark on the left and the theme toggle on the right.
/// Icons are disabled (opacity 0.35) on non-loaded states per the handoff spec.
struct ListHeaderView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    var actionsEnabled: Bool = true

    private enum Constants {
        static let height: CGFloat = 44
        static let paddingLeading: CGFloat = 22
        static let paddingTrailing: CGFloat = 16
        static let paddingTop: CGFloat = 8
        static let paddingBottom: CGFloat = 4
        static let disabledOpacity: Double = 0.35
        static let brandMark = "酒 · Sakaya"
        static let brandTracking = 0.12
        static let brandSize: Double = 14
    }

    var body: some View {
        HStack(alignment: .center) {
            Text(Constants.brandMark)
                .font(.brandMark)
                .tracking(em: Constants.brandTracking, size: Constants.brandSize)
                .foregroundColor(.ink)

            Spacer()

            themeButton
                .opacity(actionsEnabled ? 1 : Constants.disabledOpacity)
                .disabled(!actionsEnabled)
        }
        .padding(.leading, Constants.paddingLeading)
        .padding(.trailing, Constants.paddingTrailing)
        .padding(.top, Constants.paddingTop)
        .padding(.bottom, Constants.paddingBottom)
        .frame(height: Constants.height)
    }

    // MARK: - Theme Toggle

    private var themeButton: some View {
        let iconName = themeManager.appearance.iconName(resolvedScheme: colorScheme)
        return IconButton(systemName: iconName, accessibilityLabel: themeToggleLabel) {
            themeManager.cycle()
        }
    }

    private var themeToggleLabel: String {
        switch themeManager.appearance {
        case .system, .light: return Strings.ListHeader.switchToDark
        case .dark:           return Strings.ListHeader.switchToLight
        }
    }
}

// MARK: - Preview

#Preview("Actions enabled") {
    ListHeaderView(actionsEnabled: true)
        .environmentObject(ThemeManager())
        .background(Color.bg)
}

#Preview("Actions disabled") {
    ListHeaderView(actionsEnabled: false)
        .environmentObject(ThemeManager())
        .background(Color.bg)
}
