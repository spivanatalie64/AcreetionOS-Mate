#!/usr/bin/env bash

# AcreetionOS MATE Edition Build Script
# Enhanced for CI/CD automation with versioning and checksums

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCH="${1:-x86_64}"
OUTPUT_DIR="${OUTPUT_DIR:-${SCRIPT_DIR}/../ISO}"
BUILD_LOG="${SCRIPT_DIR}/build-${ARCH}-$(date +%s).log"
SKIP_TERMS="${SKIP_TERMS:-0}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}ℹ️  $*${NC}"; }
log_success() { echo -e "${GREEN}✅ $*${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
log_error() { echo -e "${RED}❌ $*${NC}"; }

# Change to script directory
cd "$SCRIPT_DIR"

# 1. Terms of Use & Acceptance (skip in CI environments)
if [[ "${SKIP_TERMS}" -eq 0 ]]; then
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
      log_error "Build cancelled. You must accept the terms to build AcreetionOS."
      exit 1
  fi
fi

log_success "Terms accepted. Initializing build..."
echo ""

# 2. Verify architecture
case "$ARCH" in
  x86_64|i686|aarch64|armv7h|riscv64)
    log_info "Target Architecture: $ARCH"
    ;;
  *)
    log_error "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# 3. Cleanup previous build artifacts
log_info "Cleaning up previous build work..."
sudo rm -rf "${SCRIPT_DIR}/work/"
mkdir -p "${OUTPUT_DIR}"
log_success "Workspace cleaned"

# 4. Generate build metadata
log_info "Generating build metadata..."
export BUILD_SYSTEM="${BUILD_SYSTEM:-local}"
export ARCH
chmod +x ./generate-build-info.sh
./generate-build-info.sh >> "${BUILD_LOG}" 2>&1 || log_warn "Build info generation had issues"

# 5. Setup environment variables
export PACMAN_OPTS="--overwrite '*'"

# 6. Run the build
log_info "Starting AcreetionOS MATE Build for ${ARCH}..."
echo "Build log: ${BUILD_LOG}"

if sudo -E ./mkarchiso_wrapper -L "AcreetionOS-MATE" -v -o "${OUTPUT_DIR}" . -C "./pacman.${ARCH}.conf" 2>&1 | tee -a "${BUILD_LOG}"; then
  log_success "Build process completed"
else
  log_error "Build process failed - check ${BUILD_LOG} for details"
  exit 1
fi

# 7. Verify ISO was created
log_info "Verifying build output..."
FOUND_ISO=$(find "${OUTPUT_DIR}" -name "AcreetionOS-MATE*${ARCH}*.iso" -type f 2>/dev/null | tail -1)

if [[ -z "$FOUND_ISO" ]]; then
  log_error "Build failed: ISO not found in ${OUTPUT_DIR}/"
  echo "Contents of ${OUTPUT_DIR}:"
  ls -lh "${OUTPUT_DIR}/" || true
  exit 1
fi

log_success "Build Successful!"
log_info "ISO Location: $FOUND_ISO"
ls -lh "$FOUND_ISO"

# 8. Generate checksums
log_info "Generating checksums..."
cd "${OUTPUT_DIR}"
sha256sum "$(basename "$FOUND_ISO")" > "$(basename "$FOUND_ISO").sha256"
md5sum "$(basename "$FOUND_ISO")" > "$(basename "$FOUND_ISO").md5"
log_success "Checksums generated:"
cat "$(basename "$FOUND_ISO").sha256"

# 9. Create build report
cat > "${OUTPUT_DIR}/BUILD_REPORT.txt" <<EOF
===================================================
AcreetionOS MATE Build Report
===================================================
Build Date: $(date)
Architecture: ${ARCH}
ISO File: $(basename "$FOUND_ISO")
ISO Size: $(du -h "$FOUND_ISO" | cut -f1)
Build Log: ${BUILD_LOG}
===================================================
EOF

log_success "Build report created"
echo ""
log_success "=========================================="
log_success "Build completed successfully!"
log_success "=========================================="
