import SwiftUI

// MARK: - PrimaryButton

/// Flat ink-slab CTA — background `ink`, text `bg`, border-radius 2pt.
/// Used for "Open in Maps" on the detail screen.
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    private enum Constants {
        static let cornerRadius: CGFloat = 2
        static let paddingV: CGFloat = 16
        static let paddingH: CGFloat = 20
        static let iconSize: CGFloat = 14
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.buttonLabel)
                    .tracking(em: 0.02, size: 14)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.medium)
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
            }
            .foregroundColor(.bg)
            .padding(.vertical, Constants.paddingV)
            .padding(.horizontal, Constants.paddingH)
            .background(Color.ink)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Open in Maps") {}
        PrimaryButton(title: "Open in Maps") {}
            .preferredColorScheme(.dark)
    }
    .padding(24)
    .background(Color.bg)
}
