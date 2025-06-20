# ./docker/android-tester/Dockerfile

# Start from a pre-configured Android image (Android 11 + emulator)
FROM budtmo/docker-android:emulator_11.0

# ----- SYSTEM SETUP -----
# Install Node.js (for Appium/WebdriverIO)
USER root

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ----- EMULATOR CONFIG -----
# Copy pre-optimized emulator config
COPY docker/android-tester/emu-config.ini /root/.android/avd/Pixel_4.avd/config.ini

# ----- TEST ENVIRONMENT -----
WORKDIR /app

# Cache npm dependencies first (faster rebuilds)
COPY CMS_Android_E2E_tests/package*.json ./
RUN npm install

# Copy test code and APK
COPY CMS_Android_E2E_tests/ ./
COPY apps/ /root/tests/apps/

# ----- HEALTH CHECK -----
# Wait for emulator to fully boot
HEALTHCHECK --interval=5s --timeout=3s \
  CMD adb shell getprop sys.boot_completed | grep 1

# ----- ENTRYPOINT -----
# Startup script (runs when container starts)
COPY docker/android-tester/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]