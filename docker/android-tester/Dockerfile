FROM budtmo/docker-android:emulator_11.0

# System setup
USER root

# Install Node.js and dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Android tools
RUN apt-get update && \
    apt-get install -y \
    android-sdk-platform-tools \
    android-sdk-build-tools \
    aapt \
    unzip \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Create AVD
RUN echo "no" | avdmanager create avd \
    -n Pixel_4 \
    -k "system-images;android-30;google_apis;x86_64" \
    --force

# Emulator configuration
COPY docker/android-tester/emu-config.ini /root/.android/avd/Pixel_4.avd/config.ini

# Set working directory
WORKDIR /app

# Install npm dependencies
COPY CMS_Android_E2E_tests/package*.json ./
RUN npm install

# Copy test code and APK
COPY CMS_Android_E2E_tests/ ./
COPY apps/ /root/tests/apps/

# Entrypoint
COPY docker/android-tester/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]