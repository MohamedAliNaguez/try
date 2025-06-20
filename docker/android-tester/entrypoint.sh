#!/bin/bash
set -e

# Start ADB server
adb start-server
echo "[$(date)] ADB started"

# Launch emulator
emulator @Pixel_4 \
  -no-audio \
  -no-boot-anim \
  -accel on \
  -gpu swiftshader_indirect \
  -memory 4096 \
  -partition-size 2048 \
  -no-snapshot \
  -wipe-data \
  &> /var/log/emulator.log &
EMULATOR_PID=$!

echo "[$(date)] Emulator started (PID: $EMULATOR_PID)"

# Wait for device
echo "[$(date)] Waiting for device..."
adb wait-for-device

# Wait for full boot
echo -n "[$(date)] Waiting for boot completion..."
while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
  sleep 5
  echo -n "."
done
echo "Ready!"

# Disable animations
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# Install APK
APK_PATH="/root/tests/apps/apk_staging_29-05-2025.apk"
if [ -f "$APK_PATH" ]; then
  echo "[$(date)] Installing APK..."
  
  # Uninstall if exists
  PACKAGE_NAME=$(aapt dump badging "$APK_PATH" | grep package: | awk -F"'" '{print $2}')
  adb uninstall $PACKAGE_NAME || true
  
  # Install with retries
  for i in {1..3}; do
    adb install -r -t -g "$APK_PATH" && break || \
    echo "Attempt $i failed, retrying..." && sleep 10
  done

  # Verify installation
  if adb shell pm list packages | grep -q "$PACKAGE_NAME"; then
    echo "[$(date)] APK installed: $PACKAGE_NAME"
  else
    echo "[$(date)] ERROR: APK installation failed!"
    exit 1
  fi
else
  echo "[$(date)] WARNING: APK not found at $APK_PATH"
  exit 1
fi

# Launch main activity
MAIN_ACTIVITY=$(aapt dump badging "$APK_PATH" | grep launchable-activity | awk -F"'" '{print $2}')
echo "[$(date)] Launching activity: $PACKAGE_NAME/$MAIN_ACTIVITY"
adb shell am start -n $PACKAGE_NAME/$MAIN_ACTIVITY

# Run tests
echo "[$(date)] Executing: $@"
exec "$@"