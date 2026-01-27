# Style & Conventions

## Swift/SwiftUI
- Use `@ObservedObject` in child views, `@StateObject` only at creation site
- Service types are `enum` (no instances), methods are `static`
- Models are `struct` conforming to `Identifiable`, `Equatable`, `Hashable` as needed
- ViewModels are `@MainActor final class: ObservableObject`
- Use Khmer text as primary, English as secondary
- System fonts with explicit sizes (`.system(size:weight:)`)
- Never use `any` type — create proper type interfaces

## File Organization
- One main type per file
- MARK comments for logical sections
- Private helper views as private structs in same file
