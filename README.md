# SakeShop iOS

A modular iOS app displaying local sake shops in Nagano, Japan. Built as a take-home challenge for the Lead Mobile Engineer position at Revelo.

---

## Architecture

The app follows **Clean Architecture with MVVM** organized in a **modular feature structure**. The architecture was designed with cross-platform parity in mind - the folder structure, naming conventions, and behavioral contracts mirror what an Android/KMP counterpart would implement.

```
SakeShop/
├── Contracts/                  ← Gherkin .feature files (cross-platform behavioral contracts)
├── Core/
│   ├── DI/                     ← DIContainer (dependency wiring)
│   ├── DesignSystem/           ← Colors, Typography, Theme, Components
│   │   └── Components/         ← PrimaryButton, SecondaryButton, ErrorPrimaryButton,
│   │                               IconButton, ShopImageView, ShopGradientPlaceholder
│   ├── Domain/
│   │   └── Models/             ← Coordinate (shared domain entity)
│   ├── Networking/             ← JSONLoader, AppError
│   ├── Extensions/             ← Strings (type-safe Localizable.strings wrapper)
│   └── Views/                  ← StarRatingView, SafariView (shared components)
├── Features/
│   ├── ShopList/
│   │   ├── Domain/
│   │   │   ├── Models/         ← Shop entity
│   │   │   └── Protocols/      ← ShopRepositoryProtocol, ShopListUseCaseProtocol
│   │   ├── Data/               ← LocalShopRepository, ShopListUseCase, ShopDTO
│   │   └── Presentation/
│   │       ├── ViewModels/     ← ShopListViewModel
│   │       └── Views/          ← ShopListView, ShopRowView, ListHeaderView,
│   │                               ShopListLoadingView, ShopListEmptyView, ShopListErrorView
│   └── ShopDetail/
│       ├── Domain/
│       │   ├── Models/         ← ShopDetailDisplayData
│       │   └── Protocols/      ← ShopDetailUseCaseProtocol
│       ├── Data/               ← ShopDetailUseCase
│       └── Presentation/
│           ├── ViewModels/     ← ShopDetailViewModel
│           └── Views/          ← ShopDetailView, DetailDefinitionRow
└── SakeShopTests/
    ├── Helpers/                ← ShopFactory (test data builder)
    ├── Mocks/                  ← MockShopRepository, MockShopListUseCase, MockShopDetailUseCase
    └── Features/               ← Unit tests mirroring the feature structure
```

### Layer responsibilities

| Layer | Responsibility |
|---|---|
| **Domain** | Entities, protocol contracts (repository + use case interfaces) |
| **Data** | Protocol implementations, DTOs, JSON mapping, local data source |
| **Presentation** | ViewModels (state management), SwiftUI Views |
| **Core** | Shared infrastructure: DI, design system, error handling, string resources |

---

## BDD Contracts

Behavioral contracts are defined as Gherkin `.feature` files under `Contracts/`. These are the **source of truth for expected behavior** across platforms - the same files would be implemented on Android using Espresso + Cucumber.

This approach was used in production at Disney Streaming to ensure consistent behavior across Disney+, ESPN, and Star+ on multiple platforms.

```
Contracts/
├── shop_list.feature       ← List display, navigation, shop identity validation
├── shop_detail.feature     ← Detail display, maps link, website, null handling
└── data_loading.feature    ← Loading states, empty, error, retry, malformed data
```

Every unit test references its corresponding Gherkin scenario via `// BDD:` inline comments, providing direct traceability from contract to implementation.

---

## Dependencies

None. The project uses only Apple frameworks:

- `SwiftUI` - UI framework
- `Foundation` - data layer
- `Combine` - `ObservableObject` / `@Published`
- `SafariServices` - in-app website browsing
- `XCTest` - unit testing

---

## Setup

1. Clone the repository
2. Open `SakeShop.xcodeproj` in Xcode 26.5+
3. Select any iOS 26+ simulator
4. **⌘+B** to build
5. **⌘+R** to run
6. **⌘+U** to run unit tests

No package installation or environment configuration required.

---

## Android / KMP Counterpart

The developer - coming from an Android background at Disney Streaming - designed an architecture that works equally well on both platforms and would be fully acceptable in a KMP context. The naming conventions, layer responsibilities, and behavioral contracts are platform-agnostic by intent.

| iOS | Android/KMP |
|---|---|
| `Protocol` | `interface` |
| `CodingKeys` | `@SerializedName` |
| `Localizable.strings` + `Strings.swift` | `strings.xml` |
| `ShopListViewModel: ObservableObject` | `ShopListViewModel: ViewModel` |
| `@Published var state` | `StateFlow<ViewState>` |
| `async/await` | `coroutines / suspend` |
| `XCTest` + Given/When/Then | `Espresso` + `Cucumber` + same `.feature` files |
| `DIContainer` | `Hilt module` |
| `AsyncImage` + `ShopImageView` | `Coil` + custom composable |
| `maps://` scheme | `Intent(ACTION_VIEW, Uri.parse("geo:..."))` |
| `ThemeManager` + `@AppStorage` | `AppCompatDelegate` + `DataStore` |

The `Contracts/` folder and its `.feature` files are identical - shared behavioral contracts, platform-specific implementations.

---

## What's Next

For long-term maintainability, the following would be prioritized:

- **Swift Package Manager modules** - extract each feature into its own SPM package to enforce hard architectural boundaries and reduce build times
- **Remote data source** - implement `RemoteShopRepository` conforming to `ShopRepositoryProtocol`; swap in `DIContainer` with zero changes to the rest of the app
- **UI tests** - implement the Gherkin scenarios as XCUITest steps using the existing `.feature` contracts

---

## AI Engineering

This project was built in full collaboration with **Claude Design** and **Claude Code** (Anthropic) - not as an autocomplete tool, but as a genuine engineering and design partner. The result is a product that is clean, visually polished, and architecturally consistent because of how that collaboration was structured, not in spite of AI being involved.

This section documents honestly how the work happened: the roles, the decisions, the iterations, and the mistakes.

---

### What the developer brought

The developer is a Senior Android Architect applying for a Lead Mobile Engineer role. He arrived with the full architectural vision already defined - not as a vague direction, but as a concrete blueprint built on production experience at Disney Streaming. The AI's job was always implementation, never design authority.

Specific decisions that came entirely from the developer:

| Decision | Rationale |
|---|---|
| Clean Architecture + MVVM, modular feature structure | Production standard; enforced from the first file |
| Cross-platform BDD contract strategy using Gherkin `.feature` files | Used at Disney Streaming to align Disney+, ESPN, and Star+ behavior across platforms |
| Mirror iOS/Android folder structure and naming conventions | Explicit requirement for cross-platform navigability - any engineer, including junior AI engineers, should be able to navigate both codebases without friction |
| Platform-agnostic wording in Gherkin (`maps app` not `Apple Maps`) | Contracts must describe behavior, not platform specifics - the same `.feature` file runs on both platforms unchanged |
| Layer-by-layer approval gate: implement one layer, pause, review, then proceed | Set as an explicit constraint - no code advanced without developer sign-off |
| `private enum Constants` per file - no global constants file | Avoids the god-file anti-pattern; keeps each file self-contained |
| All user-facing strings through `Strings.swift` - no literals in Views or ViewModels | Compile-time safety; mirrors Android's `strings.xml` pattern |
| Apple Maps native integration via coordinates, Google Maps as fallback | Developer identified the UX gap after testing on a real device |
| `#Preview` coverage on all views - identified as a missing standard | Developer caught this during a code review pass and enforced it |

---

### What Claude brought

**Claude Design** designed the UI before any code was written. Given only the aesthetic direction "MUJI / Kinfolk editorial", it produced a complete hi-fi design specification:

- A full semantic color token system with light and dark values - `bg`, `ink`, `inkMuted`, `inkSoft`, `accent`, `surface2`, `divider`, `dividerStrong`
- A named typography scale with exact sizes, weights, letter-spacing, and line-height ratios - `display`, `eyebrow`, `detailTitle`, `bodyText`, `monoIndex`, `monoCaption`, `monoSmall`, `monoCoord`, `brandMark`
- Pixel-level layout specs for every screen and component: list rows, detail view, loading skeleton, empty state, error state, all button variants, icon button, star rating in both display modes
- The image placeholder concept - hue-driven gradients with sake bottle and cup silhouettes, deterministic hue derived from the shop name so the same shop always renders the same palette across launches, badge states for "no photo" and "error loading"
- Skeleton shimmer animation with per-row width ratios to simulate the actual content shape
- Dark mode token inversion and theme toggle cycle behavior

The developer reviewed and approved the spec in full before implementation began. No design token or layout measurement was authored manually.

**Claude Code** (the CLI) was the primary engineering partner for everything that followed - architecture, code, tests, debugging, refactoring, and documentation. It wrote the vast majority of the Swift code in this repository, under the developer's direction and review at every step.

---

### The real process - iterative, not linear

The finished product did not come from a single prompt. It came from a disciplined loop: generate → test on device → identify what's wrong → diagnose the root cause → fix → repeat. The developer set the standard for what "done" meant at each step, and the bar kept rising.

**Round 1 - Architecture, BDD contracts, core layers**

The developer arrived with the full architectural blueprint already defined - drawn from his production experience at Disney Streaming: Clean Architecture, modular feature structure, Gherkin `.feature` files as cross-platform behavioral contracts, folder naming mirroring what an Android counterpart would implement, and a layer-by-layer approval gate set as an explicit constraint from the start. Claude Code's role was implementation: generate one layer, pause, await developer review, then proceed. It generated domain entities, protocol contracts, DTOs, repositories, use cases, ViewModels, and an initial set of SwiftUI views in that sequence. Minor issues were caught during review: argument order errors in tests, missing `import Combine`, magic strings in internal error types.

**Round 2 - Visual design specification**

Before touching any UI code, the developer directed Claude Design to produce a complete hi-fi design spec. This was a deliberate gate the developer imposed: code without a spec produces visual debt. Claude Design delivered the full design system - colors, typography, components, interactions, dark mode - as a written specification. The developer reviewed and approved before implementation began.

**Round 3 - Design system implementation → first build failures**

Claude Code translated the spec into Swift across 14 new files. The build failed immediately - all files were on disk but none were registered in the `.xcodeproj`. Xcode project files use a complex internal format; Claude Code diagnosed the issue and fixed it by writing a Ruby script using the `xcodeproj` gem to programmatically register all files. Second build failure: `ThemeManager does not conform to ObservableObject`. Root cause: `import SwiftUI` alone does not pull in Combine; `@Published` requires an explicit `import Combine`. Fixed. App ran for the first time.

**Round 4 - First review cycle: simulator testing + code audit**

The developer ran the app on the simulator and followed up with a thorough code audit - two separate passes that each caught different categories of issues.

The simulator surfaced runtime problems: image layout displacement when opening a shop with a photo (`AsyncImage` success phase expanding the parent `ZStack` beyond the proposed frame), and a dark/light mode toggle that required two taps due to `ThemeManager` having both `@Published` and `@AppStorage` for the same value, causing a double-publish race condition.

The code audit was more significant. The developer reviewed every layer against the architectural standards he had set and found: coordinates present in the data but never rendered on the detail screen; display formatting logic (`derivedCity`, `cleanedWebsiteURL`) computed directly in the View instead of the domain layer where it belongs; magic strings scattered throughout the new design instead of being routed through `Strings.swift`; obsolete files left over from the original scaffold (`ContentView.swift`, `AsyncShopImageView.swift`) that should have been deleted; and button components bundled in a single file, violating the one-struct-per-file rule. These were not bugs - they were architectural violations, and the developer caught every one of them.

All resolved. One intermediate build failure: `ShopListViewModel` referenced a `Strings` key renamed during the rewrite. Updated and green.

**Round 5 - Second review cycle: image state model redesign**

The developer tested again, found the image displacement still occurring, and specified the intended image UX precisely: nil URL shows the gradient placeholder immediately with no network call; loading shows a gray rectangle with a spinner; success crossfades the real photo; failure shows the gradient with an error badge. He also caught that coordinates were displaying 6 decimal places when 3 is sufficient.

The definitive layout fix was a pattern change: `Color.clear.aspectRatio(3/2).overlay { ShopImageView }` - container size driven by `Color.clear`, not by the loaded image. This also resolved the "NO PHOTO" badge not appearing. `ShopImageView` and `ShopGradientPlaceholder` were restructured to implement the model cleanly.

**Round 6 - Apple Maps native integration**

The developer identified that opening the Google Maps link on iPhone is poor UX - Apple Maps is the native, expected behavior. His requirement: use coordinates to build an Apple Maps URL when available, fall back to the Google Maps link otherwise. This logic belongs entirely in the use case layer - the View receives a single `mapsLink: URL?` and calls `UIApplication.shared.open()` with no branching.

`ShopDetailUseCase` was updated to generate `maps://?ll={lat},{lon}&q={name}` when coordinates are present, falling back to `shop.googleMapsLink` otherwise. Four new BDD scenarios were added covering: coordinates present (Apple Maps), no coordinates with Google link (fallback), both present (Apple Maps wins), neither (nil, button hidden). All tests pass.

**Round 7 - Final pass: previews, cleanup, polish**

The developer noticed that none of the 15 SwiftUI view files had `#Preview` blocks - he identified this as a missing standard, not a feature request. Claude Code added preview blocks to all view files: components (all button variants, icon button, star rating modes, gradient placeholder badge states, image view states), state views (loading skeleton, empty, error), list rows, header, detail view, and the full `ShopListView` wired to the real `DIContainer` loading actual JSON. No mocking required.

Final cleanup before commit:
- `city` eyebrow removed from the detail screen header - shop name alone is sufficient
- `city` computed property removed from `ShopDetailDisplayData` - dead code
- Magic strings in `ShopDetailDisplayData` extracted to private named constant enums: `URLScheme` (`"https://"`, `"http://"`, `"/"`) and `Format` (`"%.3f, %.3f"`)
- Duplicate `.xcodeproj` compile sources cleaned - the Round 3 Ruby script had added explicit `PBXBuildFile` entries for files already picked up by `fileSystemSynchronizedGroups` (Xcode's automatic folder sync). Every registered file was compiling twice, producing warnings on every build. All explicit entries removed; folder sync handles compilation.
- App display name set to "Sakaya" via `INFOPLIST_KEY_CFBundleDisplayName` build setting

---

### What makes the output quality high

The code in this repository is clean, consistent, and well-structured not because AI naturally produces that - it doesn't by default. It's because every output was held to a standard:

- The developer enforced architectural constraints at every layer ("this logic belongs in the use case, not the view")
- No string literal reached a View or ViewModel without going through `Strings.swift`
- Every visual change was validated on the actual simulator, not just assumed correct from code review
- Bugs were diagnosed to their root cause before being fixed - not patched around
- Each component was given a clear, single responsibility
- The test suite maintained full Gherkin traceability throughout, even as the codebase evolved

The AI provided velocity. The developer provided the standard.

---

### Tools used

| Tool | Role |
|---|---|
| **Claude Design** | Visual design: complete hi-fi design specification before any code was written |
| **Claude Code CLI** (`claude-sonnet-4-6`) | Engineering: all Swift implementation, debugging, refactoring, test writing, documentation |
