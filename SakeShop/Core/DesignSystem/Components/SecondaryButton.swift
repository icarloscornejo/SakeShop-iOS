import SwiftUI

// MARK: - SecondaryButton

/// Outlined secondary button — transparent background, 1pt `dividerStrong` border, border-radius 2pt.
/// Used in the empty state for "Refresh".
struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    private enum Constants {
        static let cornerRadius: CGFloat = 2
        static let paddingV: CGFloat = 12
        static let paddingH: CGFloat = 28
        static let borderWidth: CGFloat = 1
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.stateButton)
                .tracking(em: 0.04, size: 13.5)
                .foregroundColor(.ink)
                .padding(.vertical, Constants.paddingV)
                .padding(.horizontal, Constants.paddingH)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .strokeBorder(Color.dividerStrong, lineWidth: Constants.borderWidth)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        SecondaryButton(title: "Refresh") {}
        SecondaryButton(title: "Refresh") {}
            .preferredColorScheme(.dark)
    }
    .padding(24)
    .background(Color.bg)
}
