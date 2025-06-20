#!/bin/bash
# ./docker/android-tester/entrypoint.sh
set -e

# 1. Start ADB
adb start-server
echo "[$(date)] ADB started"

# 2. Launch emulator
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

# 3. Wait for device
echo "[$(date)] Waiting for device..."
adb wait-for-device

# 4. Wait for full boot
echo -n "[$(date)] Waiting for boot completion..."
while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
  sleep 5
  echo -n "."
done
echo "Ready!"

# 5. Disable animations
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# 6. Install APK
APK_PATH="/root/tests/apps/apk_staging_29-05-2025.apk"
if [ -f "$APK_PATH" ]; then
  echo "[$(date)] Installing APK..."
  
  # Retry logic
  for i in {1..3}; do
    adb install -r -t -g "$APK_PATH" && break || \
    echo "Attempt $i failed, retrying..." && sleep 10
  done

  # Verify
  PACKAGE=$(aapt dump badging "$APK_PATH" | grep package: | awk -F"'" '{print $2}')
  if adb shell pm list packages | grep -q "$PACKAGE"; then
    echo "[$(date)] APK installed: $PACKAGE"
  else
    echo "[$(date)] ERROR: APK installation failed!"
    exit 1
  fi
else
  echo "[$(date)] WARNING: APK not found at $APK_PATH"
fi

# 7. Execute command
echo "[$(date)] Running: $@"
exec "$@"