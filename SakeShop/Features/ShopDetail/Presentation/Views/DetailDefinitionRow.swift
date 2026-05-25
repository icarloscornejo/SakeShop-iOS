import SwiftUI

// MARK: - DetailDefinitionRow

/// A single dt/dd pair in the definition list on the detail screen.
/// Grid is implemented at the parent level via a consistent `termWidth`.
struct DetailDefinitionRow: View {
    let term: String
    let value: String
    /// When non-nil, tapping the value opens this URL.
    var actionURL: URL? = nil
    /// When `true`, value renders in `monoCoord` font (coordinate row).
    var isMono: Bool = false
    /// When `true`, the row is hidden entirely (e.g., website row when URL is missing).
    var isHidden: Bool = false
    /// Alternative action for opening website via SFSafariViewController.
    var onWebsiteTap: (() -> Void)? = nil

    private enum Constants {
        static let termWidth: CGFloat = 90
        static let columnGap: CGFloat = 16
        static let rowGap: CGFloat = 12
        static let termTracking = 0.18
        static let termSize: Double = 10
        static let linkUnderlineOffset: CGFloat = 3
        static let linkUnderlineThickness: CGFloat = 1
    }

    var body: some View {
        if !isHidden {
            HStack(alignment: .top, spacing: Constants.columnGap) {
                Text(term)
                    .font(.eyebrow)
                    .tracking(em: Constants.termTracking, size: Constants.termSize)
                    .textCase(.uppercase)
                    .foregroundColor(.inkMuted)
                    .frame(width: Constants.termWidth, alignment: .leading)

                valueView
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var valueView: some View {
        if let url = actionURL {
            Button {
                UIApplication.shared.open(url)
            } label: {
                linkText
            }
            .buttonStyle(.plain)
        } else if let onWebsiteTap {
            Button(action: onWebsiteTap) {
                linkText
            }
            .buttonStyle(.plain)
        } else {
            Text(value)
                .font(isMono ? .monoCoord : .bodySmall)
                .foregroundColor(.ink2)
                .multilineTextAlignment(.leading)
        }
    }

    private var linkText: some View {
        Text(value)
            .font(isMono ? .monoCoord : .bodySmall)
            .foregroundColor(.accent)
            .underline(true, color: .accent)
            .multilineTextAlignment(.leading)
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        DetailDefinitionRow(term: "Address", value: "長野県諏訪郡富士見町落合10116-2")
        DetailDefinitionRow(
            term: "Address",
            value: "長野県諏訪郡富士見町落合10116-2",
            actionURL: URL(string: "maps://?ll=36.6959,138.2113")
        )
        DetailDefinitionRow(
            term: "Website",
            value: "masumi.co.jp",
            onWebsiteTap: {}
        )
        DetailDefinitionRow(
            term: "Coordinates",
            value: "36.695, 138.211",
            isMono: true
        )
        DetailDefinitionRow(term: "Hidden", value: "never shown", isHidden: true)
    }
    .padding(24)
    .background(Color.bg)
}
