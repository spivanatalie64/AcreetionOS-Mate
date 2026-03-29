#!/bin/bash

# AcreetionOS MATE Build Info Generator
# Generates build-time metadata for automation and tracking

set -e

GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
GIT_COMMIT_FULL=$(git rev-parse HEAD 2>/dev/null || echo "N/A")
BUILD_DATE=$(date -u +'%Y-%m-%d %H:%M:%S UTC')
BUILD_DATE_EPOCH=$(date +%s)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
GIT_USER=$(git config user.name 2>/dev/null || echo "Builder")
ARCH="${ARCH:-x86_64}"

# Build serial (identifies the specific ISO build)
BUILD_SERIAL=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 8 | head -n 1)

# Try to get version from git tag or use timestamp
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "nightly-$(date +%Y%m%d)")

BUILD_INFO="# AcreetionOS MATE Edition Build Information
# Generated: ${BUILD_DATE}

EDITION=AcreetionOS-MATE
VERSION=${VERSION}
BUILD_SERIAL=MATE-${BUILD_SERIAL}
ARCHITECTURE=${ARCH}
GIT_COMMIT=${GIT_COMMIT}
GIT_COMMIT_FULL=${GIT_COMMIT_FULL}
GIT_BRANCH=${GIT_BRANCH}
BUILD_DATE=${BUILD_DATE}
BUILD_DATE_EPOCH=${BUILD_DATE_EPOCH}
BUILD_USER=${GIT_USER}
BUILD_SYSTEM=${BUILD_SYSTEM:-local}
BUILD_HOST=$(hostname 2>/dev/null || echo "unknown")"

mkdir -p airootfs/etc
echo "$BUILD_INFO" > airootfs/etc/acreetion-build-info
echo "✅ Generated build info at airootfs/etc/acreetion-build-info"
echo "Version: ${VERSION} | Arch: ${ARCH} | Commit: ${GIT_COMMIT}"
