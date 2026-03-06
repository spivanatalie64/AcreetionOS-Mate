#!/bin/bash

# AcreetionOS Lite Build Info Generator
# Generates build-time metadata including a build-specific serial.

GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
BUILD_DATE=$(date)
GIT_USER=$(git config user.name 2>/dev/null || echo "Builder")
# Build serial (identifies the specific ISO build)
BUILD_SERIAL=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 8 | head -n 1)

BUILD_INFO="Edition: AcreetionOS Lite
Build Serial: LITE-BUILD-$BUILD_SERIAL
Commit: $GIT_COMMIT
Date: $BUILD_DATE
User: $GIT_USER"

echo "$BUILD_INFO" > airootfs/etc/acreetion-build-info
echo "Generated build info at airootfs/etc/acreetion-build-info"
