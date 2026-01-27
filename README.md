<div align="center">

# Khmer Calendar Bar

**A native macOS menu bar app for the Khmer Chhankitek lunisolar calendar.**

[![macOS](https://img.shields.io/badge/macOS-14.0%2B-000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-007AFF?logo=swift&logoColor=white)](https://developer.apple.com/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-2E9494)](LICENSE)

[Download DMG](#download) | [Build from Source](#build-from-source) | [Features](#features)

</div>

---

<div align="center">
  <img src="docs/images/preview.png" alt="Khmer Calendar Bar Preview" width="520">
  <p><em>Modern Dark Teal theme with Khmer lunar dates, public holidays, and working day status</em></p>
</div>

---

## Download

### Latest Release

> **[Download KhmerCalendarBar.dmg](https://github.com/RithyTep/KhmerCalendarBar/releases/latest)**

Or download the `.zip` from the [Releases](https://github.com/RithyTep/KhmerCalendarBar/releases) page.

### Install

1. Open `KhmerCalendarBar.dmg`
2. Drag **Khmer Calendar Bar** to your **Applications** folder
3. Open from Applications or Spotlight
4. The calendar icon appears in your menu bar

> **Requires macOS 14.0 Sonoma or later** (Apple Silicon + Intel)

---

## Features

### Calendar
- **Khmer Chhankitek Engine** — Full Gregorian ↔ Khmer lunisolar date conversion
- **Dual Calendar Grid** — Gregorian dates with Khmer lunar dates underneath
- **Lunar Phases** — កើត (waxing) / រោច (waning) display on every day
- **Buddhist Era** — ពុទ្ធសករាជ year display
- **Animal Year Cycle** — 12-year Khmer animal cycle (ជូត, ឆ្លូវ, ខាល, ...)
- **Sak Era** — 10 Sak cycle (ឯកស័ក, ទោស័ក, ...)
- **Khmer Numerals** — Full Unicode Khmer numeral display (០១២៣៤៥៦៧៨៩)

### Holidays (Cambodian Public Holidays)
- **Fixed Gregorian holidays** — New Year, Victory Day, Women's Day, Workers' Day, King's Birthday, Constitution Day, Independence Day
- **Lunar-computed holidays** — Khmer New Year, Visak Bochea, Pchum Ben, Water Festival, Meak Bochea
- **Holiday indicators** — Coral dots on calendar days, detailed holiday list per month
- **Next holiday countdown** — Shows upcoming holiday with days remaining

### UX
- **Working day status** — "ថ្ងៃធ្វើការ" / "ថ្ងៃឈប់សម្រាក" / "ចុងសប្តាហ៍" badge
- **Modern Dark Teal theme** — Custom color palette (teal, coral, amber)
- **Spring animations** — Smooth month navigation, hover effects, scale transitions
- **Month slide transitions** — Directional left/right animation when navigating
- **Day cell hover** — Interactive scale effect on mouseover
- **Keyboard shortcuts** — Arrow keys (month), T (today), Escape (deselect)
- **Launch at Login** — Auto-start on macOS boot
- **Midnight refresh** — Automatically updates at midnight
- **Holiday notifications** — macOS notifications for upcoming holidays

---

## Build from Source

### Prerequisites
- macOS 14.0+
- Xcode 15+ or Swift 5.9+ toolchain

### Build

```bash
# Clone
git clone https://github.com/RithyTep/KhmerCalendarBar.git
cd KhmerCalendarBar

# Debug build
swift build

# Release build + .app bundle + .zip
./build-app.sh
```

### Install from Build

```bash
cp -R KhmerCalendarBar.app /Applications/
open /Applications/KhmerCalendarBar.app
```

---

## Architecture

```
KhmerCalendarBar/
├── Models/
│   ├── KhmerDate.swift           # Core Khmer date struct
│   ├── KhmerMonth.swift          # 12+2 lunar months
│   ├── KhmerAnimalYear.swift     # 12 animal cycle
│   ├── KhmerSak.swift            # 10 Sak era cycle
│   ├── MoonPhase.swift           # Waxing/waning phases
│   ├── KhmerHoliday.swift        # Holiday model
│   ├── DayInfo.swift             # Combined day info for grid
│   ├── CalendarConstants.swift   # Khmer Unicode strings
│   └── CalendarTheme.swift       # Modern Dark Teal color palette
├── Engine/
│   ├── ChhankitekEngine.swift    # Main Gregorian ↔ Khmer conversion
│   ├── AstronomicalCalculations  # Aharkun, Bodethey, Avoman
│   ├── LeapYearCalculator        # Adhikameas/Adhikavar detection
│   ├── NewYearCalculator         # Khmer New Year computation
│   ├── MonthNavigator            # Month sequencing with leap
│   └── JulianDayConverter        # Julian Day Number bridge
├── Services/
│   ├── HolidayService            # Fixed + lunar holidays
│   ├── DateFormatterService      # Khmer date formatting
│   ├── KhmerNumeralService       # Arabic ↔ Khmer numerals
│   └── NotificationService       # Holiday notifications
├── ViewModels/
│   └── CalendarViewModel         # State + midnight timer + stats
├── Views/
│   ├── PopoverContentView        # Main popover layout
│   ├── TodayHeaderView           # Today header with status
│   ├── MonthNavigationView       # Month navigation + Today button
│   ├── CalendarGridView          # 7-column animated grid
│   ├── DayCellView               # Day cell with hover effects
│   ├── HolidayListView           # Monthly holidays with dates
│   └── FooterView                # Launch at Login, Quit
└── Utilities/
    ├── LaunchAtLogin              # SMAppService wrapper
    ├── CalendarIconGenerator      # App icon generator
    └── MenuBarIconGenerator       # Menu bar icon
```

## Khmer Calendar Engine

The Chhankitek engine converts Gregorian dates to Khmer lunar dates using epoch-based astronomical calculations:

1. **Julian Day Number** — Bridge between Gregorian and internal day counting
2. **Aharkun** — Days elapsed from the epoch
3. **Bodethey / Avoman** — Excess day and lunar excess calculations
4. **Leap Detection** — Determines Adhikameas (leap month, 384 days), Adhikavar (leap day, 355 days), or normal year (354 days)
5. **New Year** — Computes exact Moha Songkran date
6. **Conversion** — Skips full years → skips full months → remaining days = lunar day + phase

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

[MIT](LICENSE)

---

<div align="center">
  <sub>Built with SwiftUI for macOS by <a href="https://github.com/RithyTep">RithyTep</a></sub>
</div>
