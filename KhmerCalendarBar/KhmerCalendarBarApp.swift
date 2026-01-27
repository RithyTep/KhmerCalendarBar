import SwiftUI

@main
struct KhmerCalendarBarApp: App {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some Scene {
        MenuBarExtra {
            PopoverContentView(viewModel: viewModel)
                .frame(width: 340)
                .background(DarkModeEnforcer())
        } label: {
            Text(viewModel.menuBarText)
        }
        .menuBarExtraStyle(.window)
    }
}

/// Finds the hosting NSWindow and forces dark appearance
private struct DarkModeEnforcer: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.appearance = NSAppearance(named: .darkAqua)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if let window = nsView.window {
            window.appearance = NSAppearance(named: .darkAqua)
        }
    }
}
