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
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
</dict>
</plist>
PLIST

echo "Packaging..."
rm -f "${APP_NAME}.zip"
zip -r -q "${APP_NAME}.zip" "${APP_DIR}"

echo ""
echo "Done!"
echo "  App:  ${APP_DIR}"
echo "  Zip:  ${APP_NAME}.zip"
echo ""
echo "To install: unzip ${APP_NAME}.zip && mv ${APP_DIR} /Applications/"
