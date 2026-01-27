import SwiftUI

@main
struct KhmerCalendarBarApp: App {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some Scene {
        MenuBarExtra {
            PopoverContentView(viewModel: viewModel)
                .frame(width: 380, height: 520)
        } label: {
            Text(viewModel.menuBarText)
        }
        .menuBarExtraStyle(.window)
    }
}
