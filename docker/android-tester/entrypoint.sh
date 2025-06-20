#!/bin/bash
# docker/android-tester/entrypoint.sh

set -e

# 1. Start ADB server
adb start-server
echo "[INFO] ADB server started"

# 2. Launch emulator in background
emulator @Pixel_4 \
  -no-audio \
  -no-boot-anim \
  -accel on \
  -gpu swiftshader_indirect \
  -memory 2048 \
  -partition-size 2048 \
  -no-snapshot \
  -wipe-data \
  &> /var/log/emulator.log &

echo "[INFO] Emulator started (PID: $!)"

# 3. Wait for device to be ready
echo "[INFO] Waiting for device..."
adb wait-for-device

# 4. Wait for system boot
while true; do
  boot_complete=$(adb shell getprop sys.boot_completed | tr -d '\r')
  if [ "$boot_complete" == "1" ]; then
    break
  fi
  echo "[DEBUG] Waiting for boot completion..."
  sleep 5
done

# 5. Disable animations (optional but helps stability)
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# 6. Install APK
APK_PATH="/root/tests/apps/apk_staging_29-05-2025.apk"
if [ -f "$APK_PATH" ]; then
  echo "[INFO] Installing APK: $APK_PATH"
  adb install -r -t -g "$APK_PATH"

  # 7. Extract package name from APK
  PACKAGE_NAME=$(aapt dump badging "$APK_PATH" | grep "package: name=" | cut -d"'" -f2)
  echo "[INFO] Detected package name: $PACKAGE_NAME"

  # 8. Verify installation
  if adb shell pm list packages | grep -q "$PACKAGE_NAME"; then
    echo "[SUCCESS] APK installed: $PACKAGE_NAME"

    # 9. Launch the app
    MAIN_ACTIVITY=$(aapt dump badging "$APK_PATH" | grep launchable-activity | cut -d"'" -f2)
    echo "[INFO] Launching app: $PACKAGE_NAME/$MAIN_ACTIVITY"
    adb shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1
  else
    echo "[ERROR] APK installation failed!"
    exit 1
  fi
else
  echo "[WARNING] APK not found at $APK_PATH"
fi

# 10. Run passed command (e.g., npm test)
echo "[INFO] Executing: $@"
exec "$@"
