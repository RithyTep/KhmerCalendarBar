# KhmerCalendarBar — Project Conventions

## Project Overview
macOS menu bar app for the Khmer Chhankitek lunisolar calendar. Built with Swift/SwiftUI using Swift Package Manager (SPM). No Xcode project — pure SPM.

- **Repo**: https://github.com/RithyTep/KhmerCalendarBar
- **Website**: https://khmercalendarbar.rithytep.online/
- **Bundle ID**: `com.khmercalendar.bar`
- **Min macOS**: 14.0 Sonoma
- **Current version**: 1.2.0
- **Architecture**: Apple Silicon + Intel (universal)

## Release History
| Version | Tag | Description |
|---------|-----|-------------|
| 1.2.0 | v1.2.0 | Year overview, forced dark mode, promotional website |
| 1.1.0 | v1.1.0 | Premium UI with Modern Dark Teal theme |

## Versioning
- Semantic versioning: `MAJOR.MINOR.PATCH`
- Version is set in `build-app.sh` → Info.plist (`CFBundleVersion` + `CFBundleShortVersionString`)
- Tag format: `v1.2.0`
- Release via: `gh release create v1.X.0 KhmerCalendarBar.dmg KhmerCalendarBar.zip --title "..." --notes "..." --latest`

## Build & Release Process
```bash
# 1. Build app bundle + zip
./build-app.sh

# 2. Create DMG
hdiutil create -volname "KhmerCalendarBar" -srcfolder KhmerCalendarBar.app -ov -format UDZO KhmerCalendarBar.dmg

# 3. Install locally
cp -R KhmerCalendarBar.app /Applications/
open /Applications/KhmerCalendarBar.app

# 4. GitHub release
gh release create vX.Y.Z KhmerCalendarBar.dmg KhmerCalendarBar.zip --title "vX.Y.Z — Title" --notes "..." --latest
```

## Architecture
```
KhmerCalendarBar/
├── Models/          — Data models (KhmerDate, KhmerHoliday, DayInfo, CalendarTheme, etc.)
├── Engine/          — Chhankitek lunisolar conversion engine
├── Services/        — HolidayService, DateFormatterService, KhmerNumeralService, NotificationService
├── ViewModels/      — CalendarViewModel (single ViewModel, @MainActor)
├── Views/           — SwiftUI views (PopoverContentView is root)
├── Utilities/       — LaunchAtLogin, icon generators
└── Resources/       — AppIcon.icns
```

## Code Conventions

### Swift / SwiftUI
- **SwiftUI only** — No UIKit/AppKit views except `NSViewRepresentable` for window-level overrides
- **@MainActor** on ViewModel — `CalendarViewModel` is `@MainActor final class`
- **Single ViewModel** — `CalendarViewModel` holds all state, injected via `@StateObject` in App
- **Environment for theme** — `@Environment(\.calendarTheme)` for adaptive colors, not static access
- **Dark mode forced** — App uses `DarkModeEnforcer` (NSViewRepresentable) to force `.darkAqua` on the MenuBarExtra window
- **MenuBarExtra** with `.window` style — not `.menu`
- **Spring animations** — `.spring(response: 0.3, dampingFraction: 0.85)` is the standard
- **Khmer text** — Use Unicode Khmer script directly in source code
- **Khmer numerals** — Use `KhmerNumeralService.toKhmer()` for number display

### Naming
- Views: `*View.swift` (e.g., `CalendarGridView.swift`)
- Models: Descriptive name (e.g., `KhmerDate.swift`, `DayInfo.swift`)
- Services: `*Service.swift` (e.g., `HolidayService.swift`)
- Private sub-views: `private struct` within the same file

### Commit Messages
- Imperative mood: "Add feature", "Fix bug", "Update version"
- Short first line, optional body for details
- Co-authored: `Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>`

### Key Patterns
- **Holiday data**: `HolidayService.holidays(forYear:)` returns all holidays for a year
- **Khmer date conversion**: `ChhankitekEngine.shared.toKhmer(year:month:day:)`
- **Grid building**: `CalendarViewModel.buildGrid()` constructs 42-cell grid (6 weeks)
- **Midnight refresh**: Timer reschedules itself at midnight to update date display
- **Keyboard shortcuts**: Arrow keys (month nav), T (today), Y (year view), Escape (back/deselect)

## Important Notes
- **No Xcode project** — Pure SPM. WidgetKit extensions require `.xcodeproj` (not supported yet)
- **No test suite** — Manual testing only
- **App icon** — `.icns` in `Resources/`, copied by `build-app.sh`. Generated from `docs/images/logo.png`
- **LSUIElement = true** — App is agent-only (no Dock icon, no menu bar app menu)
- **Website** — Static HTML in `docs/`, deployed to Vercel
- **DMG download URL pattern**: `https://github.com/RithyTep/KhmerCalendarBar/releases/download/vX.Y.Z/KhmerCalendarBar.dmg`
