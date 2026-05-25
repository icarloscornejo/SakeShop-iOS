import SwiftUI

// MARK: - IconButton

/// 36×36 circular button with a `surface-2` pressed background.
/// Used in the list header for search and theme toggle.
struct IconButton: View {
    let accessibilityLabel: String
    let action: () -> Void
    let content: AnyView

    private enum Constants {
        static let size: CGFloat = 36
    }

    /// Creates an icon button with an SF Symbol glyph.
    init(systemName: String, accessibilityLabel: String, action: @escaping () -> Void) {
        self.accessibilityLabel = accessibilityLabel
        self.action = action
        self.content = AnyView(
            Image(systemName: systemName)
                .imageScale(.medium)
        )
    }

    /// Creates an icon button with arbitrary content (e.g. a custom Path shape).
    init(accessibilityLabel: String, action: @escaping () -> Void, @ViewBuilder content: () -> some View) {
        self.accessibilityLabel = accessibilityLabel
        self.action = action
        self.content = AnyView(content())
    }

    var body: some View {
        Button(action: action) {
            content
                .foregroundColor(.ink)
                .frame(width: Constants.size, height: Constants.size)
                .background(.clear)
                .contentShape(Circle())
        }
        .buttonStyle(IconButtonStyle())
        .accessibilityLabel(accessibilityLabel)
    }
}

// MARK: - Button Style

private struct IconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .fill(configuration.isPressed ? Color.surface2 : Color.clear)
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        IconButton(systemName: "sun.max", accessibilityLabel: "Theme") {}
        IconButton(systemName: "moon", accessibilityLabel: "Theme") {}
        IconButton(systemName: "chevron.left", accessibilityLabel: "Back") {}
    }
    .padding(24)
    .background(Color.bg)
}
