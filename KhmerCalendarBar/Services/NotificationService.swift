import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()
    private var isAuthorized = false

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            isAuthorized = try await center.requestAuthorization(options: [.alert, .sound])
            return isAuthorized
        } catch {
            print("[Notification] Authorization failed: \(error)")
            return false
        }
    }

    func scheduleHolidayNotifications(year: Int) async {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        center.removeAllPendingNotificationRequests()

        let holidays = HolidayService.holidays(forYear: year)
            .filter { $0.isPublicHoliday }

        let cal = Calendar.current
        let now = Date()

        for holiday in holidays {
            guard let holidayDate = holiday.gregorianDate,
                  let notifyDate = cal.date(byAdding: .day, value: -1, to: holidayDate),
                  notifyDate > now else {
                continue
            }

            var comps = cal.dateComponents([.year, .month, .day], from: notifyDate)
            comps.hour = 18
            comps.minute = 0

            let content = UNMutableNotificationContent()
            content.title = "ថ្ងៃបុណ្យស្អែក"
            content.body = "\(holiday.khmerName) — \(holiday.englishName)"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(
                identifier: "holiday-\(holiday.id)",
                content: content,
                trigger: trigger
            )

            do {
                try await center.add(request)
            } catch {
                print("[Notification] Failed to schedule \(holiday.englishName): \(error)")
            }
        }
    }
}
