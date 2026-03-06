#!/usr/bin/env bash

# AcreetionOS MATE Edition Build Script
# This script automates the ISO build process.

# Ensure we are in the project root
cd "$(dirname "$0")"

# 1. Terms of Use & Acceptance
echo "=========================================================================="
echo "⚠️  ACREETIONOS BUILD SYSTEM - TERMS OF ACCEPTANCE ⚠️"
echo "=========================================================================="
echo "By proceeding with this build, you acknowledge and agree to the following:"
echo ""
echo "1. UNDERSTANDING: You understand the build process and the experimental "
echo "   nature of this software."
echo "2. SUPPORT: For live support, we highly recommend joining our Discord"
echo "   (https://discord.gg/JTuQs4M5WD) or visiting the project root."
echo "   Email support is available at:"
echo "   - natalie@acreetionos.org"
echo "   - darren@acreetionos.org"
echo "   - developers@acreetionos.org"
echo "3. ATTRIBUTION: If you fork this project, you AGREE to provide proper "
echo "   credit to the original AcreetionOS authors. Upstreaming your changes "
echo "   is NOT required but is appreciated."
echo "=========================================================================="
echo ""
read -p "Do you accept these terms and wish to proceed? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "❌ Build cancelled. You must accept the terms to build AcreetionOS."
    exit 1
fi
echo "✅ Terms accepted. Initializing build..."
echo ""

# 2. Select Architecture
ARCH="${1:-x86_64}"
echo "🏗️ Target Architecture: $ARCH"

# 2. Cleanup previous build artifacts
echo "🧹 Cleaning up previous build work..."
sudo rm -rf work/
# Keep out/ if we want to store multiple ISOs, but for now we follow original script
# rm -rf out/

# 3. Create output directory if it doesn't exist
mkdir -p ../ISO

# 4. Setup environment variables for pacman
export PACMAN_OPTS="--overwrite '*'"
export ARCH

# 5. Run the build using the colorful wrapper
echo "🚀 Starting AcreetionOS MATE Build for $ARCH..."
sudo -E ./mkarchiso_wrapper -L AcreetionOS-MATE -v -o ../ISO . -C ./pacman.${ARCH}.conf -j $(nproc)

# 6. Final check
ISO_NAME="AcreetionOS-MATE-1.0-${ARCH}.iso"
if [ -f "../ISO/$ISO_NAME" ]; then
    echo "✅ Build Successful!"
    ls -lh "../ISO/$ISO_NAME"
else
    # Check if it was named slightly differently
    FOUND_ISO=$(ls ../ISO/AcreetionOS-MATE*${ARCH}*.iso 2>/dev/null | tail -1)
    if [ -n "$FOUND_ISO" ]; then
        echo "✅ Build Successful! (ISO found with variations: $FOUND_ISO)"
    else
        echo "❌ Build might have failed. ISO not found in ../ISO/"
    fi
fi
