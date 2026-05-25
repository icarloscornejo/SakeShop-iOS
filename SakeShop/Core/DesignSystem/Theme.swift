import Combine
import SwiftUI

// MARK: - Appearance

enum Appearance: String, CaseIterable {
    case system
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    /// Cycles system → dark → light → dark.
    /// Once the user sets an explicit mode, the toggle stays between dark and light only.
    var next: Appearance {
        switch self {
        case .system: return .dark
        case .dark:   return .light
        case .light:  return .dark
        }
    }

    func iconName(resolvedScheme: ColorScheme) -> String {
        switch self {
        case .system: return resolvedScheme == .dark ? "sun.max" : "moon"
        case .light:  return "moon"
        case .dark:   return "sun.max"
        }
    }
}

// MARK: - ThemeManager

/// Persists the user's appearance preference and exposes it to the SwiftUI tree.
/// Uses a single @AppStorage property as the source of truth to avoid double-publish
/// side-effects that can require two taps to register a state change.
final class ThemeManager: ObservableObject {
    @AppStorage("sakeShop.appearance") private var rawAppearance: String = Appearance.system.rawValue

    var appearance: Appearance {
        Appearance(rawValue: rawAppearance) ?? .system
    }

    func cycle() {
        rawAppearance = appearance.next.rawValue
    }

    var colorScheme: ColorScheme? { appearance.colorScheme }
}
