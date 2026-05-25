import SwiftUI
import UIKit

// MARK: - Color Tokens

/// Design system color tokens. Each property adapts to light/dark mode automatically.
/// Token names match the handoff README exactly so designers and engineers share vocabulary.
extension Color {
    static let bg          = Color.adaptive(light: "#faf7f2", dark: "#161310")
    static let surface     = Color.adaptive(light: "#ffffff", dark: "#1d1a16")
    static let surface2    = Color.adaptive(light: "#f4efe6", dark: "#25211c")
    static let ink         = Color.adaptive(light: "#1a1714", dark: "#f1ebde")
    static let ink2        = Color.adaptive(light: "#3d3935", dark: "#d8d1c2")
    static let inkMuted    = Color.adaptive(light: "#807972", dark: "#8a8276")
    static let inkSoft     = Color.adaptive(light: "#b3aca3", dark: "#5c554b")
    static let divider     = Color.adaptive(light: "#ece6da", dark: "#2a251e")
    static let dividerStrong = Color.adaptive(light: "#d9d2c5", dark: "#3a3429")
    static let accent      = Color.adaptive(light: "#b8342f", dark: "#d96b66")
    static let accentDeep  = Color.adaptive(light: "#8a221e", dark: "#b8342f")
    static let accentSoft  = Color.adaptive(light: "#f3e3df", dark: "#3a201c")
}

// MARK: - Private helpers

private extension Color {
    /// Builds an adaptive Color from two hex strings (light and dark appearance).
    static func adaptive(light lightHex: String, dark darkHex: String) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: darkHex)
                : UIColor(hex: lightHex)
        })
    }
}

extension UIColor {
    /// Initializes a UIColor from a 6-digit hex string (e.g., "#b8342f" or "b8342f").
    convenience init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = CGFloat((value >> 16) & 0xFF) / 255
        let g = CGFloat((value >>  8) & 0xFF) / 255
        let b = CGFloat((value      ) & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
