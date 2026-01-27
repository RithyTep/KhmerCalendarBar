import SwiftUI

struct FooterView: View {
    @State private var launchAtLogin = LaunchAtLoginHelper.isEnabled
    @State private var isQuitHovered = false

    var body: some View {
        HStack {
            Toggle("Launch at Login", isOn: $launchAtLogin)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .font(.caption)
                .onChange(of: launchAtLogin) { _, newValue in
                    LaunchAtLoginHelper.setEnabled(newValue)
                }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(isQuitHovered ? .secondary : .tertiary)
            .onHover { hovering in
                isQuitHovered = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isQuitHovered)
        }
    }
}
