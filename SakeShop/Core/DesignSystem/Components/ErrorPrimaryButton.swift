import SwiftUI

// MARK: - ErrorPrimaryButton

/// Accent-filled button for the error state "Retry" CTA.
struct ErrorPrimaryButton: View {
    let title: String
    let action: () -> Void

    private enum Constants {
        static let cornerRadius: CGFloat = 2
        static let paddingV: CGFloat = 14
        static let paddingH: CGFloat = 32
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.stateButton)
                .tracking(em: 0.04, size: 13.5)
                .foregroundColor(.white)
                .padding(.vertical, Constants.paddingV)
                .padding(.horizontal, Constants.paddingH)
                .background(Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ErrorPrimaryButton(title: "Retry") {}
        ErrorPrimaryButton(title: "Retry") {}
            .preferredColorScheme(.dark)
    }
    .padding(24)
    .background(Color.bg)
}
