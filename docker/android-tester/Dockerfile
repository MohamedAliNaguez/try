# ./docker/android-tester/Dockerfile
FROM budtmo/docker-android:emulator_11.0

# ----- SYSTEM SETUP -----
USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    nodejs \
    npm \
    aapt \
    unzip \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install specific Node.js version
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# ----- EMULATOR CONFIG -----
# Create default AVD
RUN echo "no" | avdmanager create avd \
    -n Pixel_4 \
    -k "system-images;android-30;google_apis;x86_64" \
    --force

# Copy optimized config
COPY emu-config.ini /root/.android/avd/Pixel_4.avd/config.ini

# ----- TEST ENVIRONMENT -----
WORKDIR /app

# Install dependencies first for caching
COPY CMS_Android_E2E_tests/package*.json ./
RUN npm install

# Copy test code and APK
COPY CMS_Android_E2E_tests/ ./
COPY apps/ /root/tests/apps/

# ----- HEALTH CHECK -----
HEALTHCHECK --interval=10s --timeout=5s \
    CMD adb shell getprop sys.boot_completed | grep 1

# ----- ENTRYPOINT -----
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*