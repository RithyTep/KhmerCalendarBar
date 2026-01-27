# KhmerCalendarBar

## Purpose
macOS menu bar app displaying Khmer (Cambodian) calendar dates, lunar calendar info, and public holidays.

## Tech Stack
- **Language**: Swift
- **UI**: SwiftUI (macOS 14+, MenuBarExtra with `.window` style)
- **Build**: Swift Package Manager (`Package.swift`)
- **Architecture**: MVVM (CalendarViewModel -> Views)

## Project Structure
```
KhmerCalendarBar/
  KhmerCalendarBarApp.swift         # App entry point (MenuBarExtra)
  Models/                           # Data models
    KhmerDate.swift, KhmerHoliday.swift, DayInfo.swift,
    KhmerMonth.swift, KhmerAnimalYear.swift, KhmerSak.swift,
    MoonPhase.swift, CalendarConstants.swift
  ViewModels/
    CalendarViewModel.swift          # Main ViewModel
  Views/
    PopoverContentView.swift         # Main popover layout
    TodayHeaderView.swift            # Today info header
    MonthNavigationView.swift        # Month nav with Today button
    CalendarGridView.swift           # 7-column day grid
    DayCellView.swift                # Individual day cell
    HolidayListView.swift            # Holiday list for month
    FooterView.swift                 # Launch at login + quit
  Engine/
    ChhankitekEngine.swift           # Core Khmer calendar engine
    NewYearCalculator.swift, LeapYearCalculator.swift,
    JulianDayConverter.swift, MonthNavigator.swift,
    AstronomicalCalculations.swift
  Services/
    HolidayService.swift             # Holiday data (fixed + lunar)
    DateFormatterService.swift       # Date formatting
    KhmerNumeralService.swift        # Arabic -> Khmer numeral conversion
    NotificationService.swift        # Holiday notifications
  Utilities/
    CalendarIconGenerator.swift, MenuBarIconGenerator.swift,
    LaunchAtLogin.swift
```

## Build Commands
- `swift build` — build the project
- `swift build -c release` — release build
- `./build-app.sh` — build .app bundle

## Code Style
- SwiftUI with `@ObservedObject`, `@StateObject`, `@Published`
- Service enums (no instances) for stateless helpers
- Khmer text used as primary, English as secondary
- No formal test suite
