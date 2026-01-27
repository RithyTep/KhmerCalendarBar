import AppKit
import CoreGraphics

enum MenuBarIconGenerator {

    static func generate(day: Int, isHoliday: Bool = false) -> NSImage {
        let size: CGFloat = 22
        let image = NSImage(size: NSSize(width: size, height: size), flipped: false) { _ in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }

            let rect = CGRect(x: 1, y: 1, width: size - 2, height: size - 2)
            let path = CGPath(roundedRect: rect, cornerWidth: 4, cornerHeight: 4, transform: nil)

            // Border
            ctx.addPath(path)
            ctx.setStrokeColor(NSColor.labelColor.cgColor)
            ctx.setLineWidth(1.2)
            ctx.strokePath()

            // Day number
            let dayStr = "\(day)" as NSString
            let fontSize: CGFloat = day < 10 ? 13 : 11
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: NSColor.labelColor
            ]
            let textSize = dayStr.size(withAttributes: attrs)
            let textOrigin = NSPoint(
                x: (size - textSize.width) / 2,
                y: (size - textSize.height) / 2
            )
            dayStr.draw(at: textOrigin, withAttributes: attrs)

            // Red dot for holiday
            if isHoliday {
                ctx.setFillColor(NSColor.red.cgColor)
                ctx.fillEllipse(in: CGRect(x: size - 6, y: size - 6, width: 4, height: 4))
            }

            return true
        }
        image.isTemplate = true
        return image
    }
}
