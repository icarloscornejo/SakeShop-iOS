import SwiftUI

// MARK: - Type Scale
//
// Fallback implementation using system fonts (SF Pro + New York).
// To use the final fonts from the handoff (Noto Serif JP, IBM Plex Sans,
// IBM Plex Mono), download the TTF files from Google Fonts, add them to the
// Xcode bundle, register them in Info.plist under UIAppFonts, then replace
// the .system calls below with Font.custom("<PostScript name>", size: N).
//
// Mapping:
//   Noto Serif JP  → .system(design: .serif)
//   IBM Plex Sans  → .system(design: .default)
//   IBM Plex Mono  → .system(design: .monospaced)

extension Font {
    // MARK: Serif (Noto Serif JP)

    /// 36pt · weight 400 · line-height 1.05 · tracking -0.01em — list title block.
    static let display = Font.system(size: 36, weight: .regular, design: .serif)

    /// 30pt · weight 500 · line-height 1.15 — shop name on detail screen.
    static let detailTitle = Font.system(size: 30, weight: .medium, design: .serif)

    /// 22pt · weight 500 — empty/error state title.
    static let sectionTitle = Font.system(size: 22, weight: .medium, design: .serif)

    /// 17pt · weight 500 · line-height 1.2 — shop name in list rows.
    static let rowName = Font.system(size: 17, weight: .medium, design: .serif)

    /// 14pt · weight 500 · tracking 0.12em — brand mark "酒 · Sakaya".
    static let brandMark = Font.system(size: 14, weight: .medium, design: .serif)

    // MARK: Sans-serif (IBM Plex Sans)

    /// 14pt · weight 400 · line-height 1.6 — body copy.
    static let bodyText = Font.system(size: 14, weight: .regular)

    /// 13pt · weight 400 · line-height 1.4 — secondary body, detail dd values.
    static let bodySmall = Font.system(size: 13, weight: .regular)

    /// 11.5pt · weight 400 — list sub-row (romaji · city).
    static let listSub = Font.system(size: 11.5, weight: .regular)

    /// 14pt · weight 500 · tracking 0.02em — button labels, primary CTA.
    static let buttonLabel = Font.system(size: 14, weight: .medium)

    /// 13.5pt · weight 500 · tracking 0.04em — empty/error state secondary button.
    static let stateButton = Font.system(size: 13.5, weight: .medium)

    // MARK: Monospaced (IBM Plex Mono)

    /// 10pt · uppercase · tracking 0.18em — section eyebrows.
    static let eyebrow = Font.system(size: 10, weight: .regular, design: .monospaced)

    /// 10.5pt · tracking 0.04em — meta line, detail counter, image caption.
    static let monoCaption = Font.system(size: 10.5, weight: .regular, design: .monospaced)

    /// 11pt · tabular-nums — list row index numbers and rating chip.
    static let monoIndex = Font.system(size: 11, weight: .regular, design: .monospaced)

    /// 12pt — coordinate values.
    static let monoCoord = Font.system(size: 12, weight: .regular, design: .monospaced)

    /// 9pt · uppercase · tracking 0.12em — "No photo" badge.
    static let monoSmall = Font.system(size: 9, weight: .regular, design: .monospaced)
}

// MARK: - Letter Spacing Helpers

extension View {
    /// Applies tracking in em units relative to the given font size.
    func tracking(em: Double, size: Double) -> some View {
        self.tracking(em * size)
    }
}
