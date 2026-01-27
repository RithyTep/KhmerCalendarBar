import SwiftUI

struct FooterView: View {
    @State private var launchAtLogin = LaunchAtLoginHelper.isEnabled

    var body: some View {
        HStack {
            Toggle("Launch at Login", isOn: $launchAtLogin)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .font(.system(size: 11))
                .onChange(of: launchAtLogin) { _, newValue in
                    LaunchAtLoginHelper.setEnabled(newValue)
                }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
        }
    }
}
