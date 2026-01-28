import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @ObservedObject var viewModel: CalendarViewModel
    @ObservedObject private var settings = AppSettings.shared
    @State private var launchAtLogin = LaunchAtLoginHelper.isEnabled
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        showSettings = false
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .medium))
                        Text("ថយក្រោយ")
                            .font(.system(size: 11))
                    }
                    .foregroundStyle(theme.accent)
                }
                .buttonStyle(ScaleButtonStyle())

                Spacer()

                Text("ការកំណត់")
                    .font(.system(size: 13, weight: .semibold))

                Spacer()

                // Invisible spacer to balance the back button
                Color.clear.frame(width: 60, height: 1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)

            Divider()
                .padding(.horizontal, 8)

            ScrollView {
                VStack(spacing: 16) {
                    // Menu Bar Format
                    SettingsSection(title: "ទ្រង់ទ្រាយរបារ", icon: "menubar.rectangle") {
                        VStack(spacing: 2) {
                            ForEach(MenuBarDisplayFormat.allCases) { format in
                                FormatOptionRow(
                                    format: format,
                                    isSelected: settings.menuBarFormat == format
                                ) {
                                    settings.menuBarFormat = format
                                }
                            }
                        }
                    }

                    // Notifications
                    SettingsSection(title: "ការជូនដំណឹង", icon: "bell.fill") {
                        VStack(spacing: 10) {
                            SettingsToggleRow(
                                label: "បុណ្យជាតិ",
                                subtitle: "Holiday notifications",
                                isOn: $settings.holidayNotificationsEnabled
                            )

                            Divider().opacity(0.3)

                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("ម៉ោងរំលឹក")
                                        .font(.system(size: 11, weight: .medium))
                                    Text("Default reminder time")
                                        .font(.system(size: 9))
                                        .foregroundStyle(.tertiary)
                                }

                                Spacer()

                                HStack(spacing: 4) {
                                    Picker("", selection: $settings.defaultReminderHour) {
                                        ForEach(0..<24, id: \.self) { h in
                                            Text(String(format: "%02d", h)).tag(h)
                                        }
                                    }
                                    .labelsHidden()
                                    .frame(width: 50)

                                    Text(":")
                                        .font(.system(size: 11, weight: .medium))

                                    Picker("", selection: $settings.defaultReminderMinute) {
                                        ForEach([0, 15, 30, 45], id: \.self) { m in
                                            Text(String(format: "%02d", m)).tag(m)
                                        }
                                    }
                                    .labelsHidden()
                                    .frame(width: 50)
                                }
                            }
                        }
                    }

                    // Reminders
                    SettingsSection(title: "ការរំលឹក", icon: "bell.badge.fill") {
                        ReminderListView(
                            reminders: $viewModel.reminders,
                            onDelete: { id in
                                viewModel.deleteReminder(id: id)
                            },
                            onToggle: { reminder in
                                viewModel.toggleReminder(reminder)
                            }
                        )
                    }

                    // General
                    SettingsSection(title: "ទូទៅ", icon: "gearshape.fill") {
                        SettingsToggleRow(
                            label: "បើកពេលចាប់ផ្ដើម",
                            subtitle: "Launch at Login",
                            isOn: $launchAtLogin
                        )
                        .onChange(of: launchAtLogin) { _, newValue in
                            LaunchAtLoginHelper.setEnabled(newValue)
                        }
                    }

                    // Version
                    Text("Version 1.5.0")
                        .font(.system(size: 9))
                        .foregroundStyle(.quaternary)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - Settings Section

private struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    @Environment(\.calendarTheme) private var theme

    init(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundStyle(theme.accent)
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            content()
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(theme.cardBorder, lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Format Option Row

private struct FormatOptionRow: View {
    let format: MenuBarDisplayFormat
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.calendarTheme) private var theme
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 12))
                    .foregroundStyle(isSelected ? AnyShapeStyle(theme.accent) : AnyShapeStyle(.tertiary))

                VStack(alignment: .leading, spacing: 1) {
                    Text(format.displayName)
                        .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? .primary : .secondary)
                    Text(format.description)
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)
                }

                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? theme.accentMuted : (isHovered ? theme.hoverBg : Color.clear))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Settings Toggle Row

private struct SettingsToggleRow: View {
    let label: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                Text(subtitle)
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .labelsHidden()
        }
    }
}
