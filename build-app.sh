#!/bin/bash
set -e

APP_NAME="KhmerCalendarBar"
BUNDLE_ID="com.khmercalendar.bar"
BUILD_DIR=".build/release"
APP_DIR="${APP_NAME}.app"

echo "Building ${APP_NAME} (release)..."
swift build -c release

echo "Creating app bundle..."
rm -rf "${APP_DIR}"
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

# Copy binary
cp "${BUILD_DIR}/${APP_NAME}" "${APP_DIR}/Contents/MacOS/${APP_NAME}"

# Copy resources bundle if present
if [ -d "${BUILD_DIR}/${APP_NAME}_${APP_NAME}.bundle" ]; then
    cp -R "${BUILD_DIR}/${APP_NAME}_${APP_NAME}.bundle" "${APP_DIR}/Contents/Resources/"
fi

# Copy app icon
cp "${APP_NAME}/Resources/AppIcon.icns" "${APP_DIR}/Contents/Resources/AppIcon.icns"

# Ad-hoc code sign (changes "damaged" to "unidentified developer" dialog)
echo "Code signing (ad-hoc)..."
codesign --force --deep --sign - "${APP_DIR}"

# Create Info.plist
cat > "${APP_DIR}/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.khmercalendar.bar</string>
    <key>CFBundleName</key>
    <string>KhmerCalendarBar</string>
    <key>CFBundleDisplayName</key>
    <string>Khmer Calendar</string>
    <key>CFBundleExecutable</key>
    <string>KhmerCalendarBar</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>1.5.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.5.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
</dict>
</plist>
PLIST

echo "Packaging ZIP..."
rm -f "${APP_NAME}.zip"
zip -r -q "${APP_NAME}.zip" "${APP_DIR}"

echo "Creating DMG..."
rm -f "${APP_NAME}.dmg"
create-dmg \
    --volname "${APP_NAME}" \
    --background "dmg-resources/background.png" \
    --window-pos 200 120 \
    --window-size 660 400 \
    --icon-size 120 \
    --icon "${APP_DIR}" 165 175 \
    --app-drop-link 495 175 \
    --text-size 14 \
    --no-internet-enable \
    "${APP_NAME}.dmg" \
    "${APP_DIR}" || true

echo ""
echo "Done!"
echo "  App:  ${APP_DIR}"
echo "  DMG:  ${APP_NAME}.dmg"
echo "  Zip:  ${APP_NAME}.zip"
echo ""
echo "To install: open ${APP_NAME}.dmg and drag to Applications"
