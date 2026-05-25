# SakeShop iOS

A modular iOS app displaying local sake shops in Nagano, Japan. Built as a take-home challenge for the Lead Mobile Engineer position at Revelo.

---

## Architecture

The app follows **Clean Architecture with MVVM** organized in a **modular feature structure**. The architecture was designed with cross-platform parity in mind — the folder structure, naming conventions, and behavioral contracts mirror what an Android/KMP counterpart would implement.

```
SakeShop/
├── Contracts/                  ← Gherkin .feature files (cross-platform behavioral contracts)
├── Core/
│   ├── DI/                     ← DIContainer (dependency wiring)
│   ├── Networking/             ← JSONLoader, AppError
│   ├── Extensions/             ← Strings (type-safe Localizable.strings wrapper)
│   └── Views/                  ← StarRatingView, AsyncShopImageView (shared components)
├── Features/
│   ├── ShopList/
│   │   ├── Domain/
│   │   │   ├── Models/         ← Shop entity
│   │   │   └── Protocols/      ← ShopRepositoryProtocol, ShopListUseCaseProtocol
│   │   ├── Data/               ← LocalShopRepository, ShopListUseCase, ShopDTO
│   │   └── Presentation/
│   │       ├── ViewModels/     ← ShopListViewModel
│   │       └── Views/          ← ShopListView, ShopRowView
│   └── ShopDetail/
│       ├── Domain/
│       │   ├── Models/         ← ShopDetailDisplayData
│       │   └── Protocols/      ← ShopDetailUseCaseProtocol
│       ├── Data/               ← ShopDetailUseCase
│       └── Presentation/
│           ├── ViewModels/     ← ShopDetailViewModel
│           └── Views/          ← ShopDetailView
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
| **Core** | Shared infrastructure: DI, error handling, string resources, reusable components |

---

## BDD Contracts

Behavioral contracts are defined as Gherkin `.feature` files under `Contracts/`. These are the **source of truth for expected behavior** across platforms — the same files would be implemented on Android using Espresso + Cucumber.

This approach was used in production at Disney Streaming to ensure consistent behavior across Disney+, ESPN, and Star+ on multiple platforms.

```
Contracts/
├── shop_list.feature       ← List display, navigation, shop identity validation
├── shop_detail.feature     ← Detail display, maps link, website, null handling
└── data_loading.feature    ← Loading states, empty, error, retry, malformed data
```

Every unit test references its corresponding Gherkin scenario via `// BDD:` inline comments, providing direct traceability from contract to implementation.

---

## Key Design Decisions

### `ShopDetailDisplayData` as a separate model
The detail screen receives a `Shop` entity from the list but exposes a `ShopDetailDisplayData` model to the View. This keeps URL validation logic (`isMapsLinkAvailable`, `isWebsiteAvailable`) in the domain layer — the View never decides whether a link is valid, it only reacts to the computed properties. This directly implements the BDD contracts for empty/corrupt links.

### `CodingKeys` as `@SerializedName` equivalent
`ShopDTO` uses Swift's `CodingKeys` enum to map `google_maps_link` (JSON) to `googleMapsLink` (Swift). This is the iOS equivalent of Kotlin's `@SerializedName` — readable variable names in code, decoupled from API field names.

### `Localizable.strings` + `Strings.swift`
All user-facing strings live in `Localizable.strings`. A type-safe `Strings` enum wrapper provides compile-time safety — no string literals in ViewModels or Views. This is the iOS equivalent of Android's `strings.xml`.

### `private enum Constants` per file
Constants are declared locally inside the file that uses them, not in a global constants file. This keeps each file self-contained and avoids a god-file anti-pattern.

### Image hidden in ShopList, present in code
The JSON data includes image URLs. The list screen spec does not require images, but `ShopRowView` includes `AsyncShopImageView` with `.hidden()`. When list images are enabled in the future, it's a one-line change — and the BDD contract + placeholder logic are already tested.

### No external dependencies
The app has zero third-party dependencies. `AsyncImage` (SwiftUI native) handles remote image loading with placeholder support. This reduces supply chain risk and simplifies setup.

---

## Dependencies

None. The project uses only Apple frameworks:

- `SwiftUI` — UI framework
- `Foundation` — data layer
- `Combine` — `ObservableObject` / `@Published`
- `XCTest` — unit testing

---

## Setup

1. Clone the repository
2. Open `SakeShop.xcodeproj` in Xcode 15+
3. Select any iOS 17+ simulator
4. **⌘+B** to build
5. **⌘+R** to run
6. **⌘+U** to run unit tests

No package installation or environment configuration required.

---

## Android / KMP Counterpart

The challenge is iOS-first, but the architecture was designed for cross-platform parity. For the Android counterpart:

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
| `AsyncImage` | `Coil` |

The `Contracts/` folder and its `.feature` files are identical — shared behavioral contracts, platform-specific implementations.

---

## What's Next

For long-term maintainability, the following would be prioritized:

- **Swift Package Manager modules** — extract each feature into its own SPM package to enforce hard architectural boundaries and reduce build times
- **Remote data source** — implement `RemoteShopRepository` conforming to `ShopRepositoryProtocol`; swap in `DIContainer` with zero changes to the rest of the app
- **UI tests** — implement the Gherkin scenarios as XCUITest steps using the existing `.feature` contracts
- **Pagination** — `ShopListUseCase` would expose a paginated API without touching the ViewModel contract
- **Search / filter** — addable as a new use case conforming to a `ShopFilterUseCaseProtocol`
- **Snapshot tests** — `StarRatingView` and `ShopRowView` are ideal candidates for snapshot regression testing

---

## AI Section

This project was built using **Claude Code** (Anthropic's CLI) as an AI engineering partner throughout the full development lifecycle.

### How AI was used

| Phase | AI Contribution |
|---|---|
| **BDD Contracts** | Generated initial Gherkin `.feature` files; refined iteratively based on challenge requirements and cross-platform review |
| **Architecture design** | Proposed and validated modular structure, cross-platform naming parity, and layer responsibilities |
| **Domain layer** | Generated `Shop`, `ShopDetailDisplayData`, and protocol contracts (`ShopRepositoryProtocol`, `ShopListUseCaseProtocol`, `ShopDetailUseCaseProtocol`) |
| **Data layer** | Generated `ShopDTO` with `CodingKeys`, `LocalShopRepository`, `JSONLoader`, `AppError`, and both use case implementations |
| **Presentation layer** | Generated ViewModels with typed `ViewState`, SwiftUI Views with `@ViewBuilder` decomposition, and `DIContainer` wiring |
| **Shared components** | Generated `StarRatingView` and `AsyncShopImageView` as reusable cross-feature components |
| **String resources** | Generated `Localizable.strings` and type-safe `Strings.swift` wrapper |
| **Tests & Mocks** | Generated all mock files, `ShopFactory`, and test cases with direct Gherkin traceability |
| **Code review** | Caught missing `import Combine`, magic strings in `AppError`/`JSONLoader`/`LocalShopRepository`, and argument order errors in test files |

### Engineering decisions made by the developer

- Cross-platform BDD contract strategy (based on Disney Streaming experience)
- Requirement to mirror iOS/Android folder structure for junior AI engineer navigability
- Decision to keep `AsyncShopImageView` hidden in the list (future-ready, not visible)
- Platform-agnostic wording in Gherkin (`maps app` not `Apple Maps`)
- Requirement for `private enum Constants` per file over a global constants file
- Approval of each architectural layer before proceeding to the next

### AI tools used

- **Claude Code CLI** (`claude-sonnet-4-6`) — primary engineering assistant
- **Prompt strategy** — iterative review-and-approve cycle per phase; no code was committed without developer review and explicit approval

> The AI accelerated implementation velocity while the developer maintained full architectural ownership and quality gatekeeping at every phase.
