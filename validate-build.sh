#!/bin/bash

# AcreetionOS MATE Build Validator
# Validates CI/CD configuration and build readiness

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check() { echo -e "${BLUE}→${NC} $*"; }
pass() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
fail() { echo -e "${RED}✗${NC} $*"; exit 1; }

echo "=========================================="
echo "AcreetionOS MATE Build Validator"
echo "=========================================="
echo ""

# 1. Check git configuration
check "Checking Git configuration..."
if git config user.name > /dev/null 2>&1; then
  USER_NAME=$(git config user.name)
  pass "Git user configured: $USER_NAME"
else
  warn "Git user not configured"
fi

# 2. Check build scripts exist
check "Checking build scripts..."
[[ -f "build-mate.sh" ]] && pass "build-mate.sh exists" || fail "build-mate.sh not found"
[[ -f "generate-build-info.sh" ]] && pass "generate-build-info.sh exists" || fail "generate-build-info.sh not found"
[[ -f "profiledef.sh" ]] && pass "profiledef.sh exists" || fail "profiledef.sh not found"

# 3. Check package files
check "Checking package lists..."
for arch in x86_64 aarch64 armv7h i686 riscv64; do
  if [[ -f "packages.${arch}" ]]; then
    count=$(wc -l < "packages.${arch}")
    pass "packages.${arch}: $count lines"
  else
    warn "packages.${arch} not found (optional)"
  fi
done

# 4. Check pacman configs
check "Checking Pacman configurations..."
for arch in x86_64 aarch64 armv7h i686 riscv64; do
  if [[ -f "pacman.${arch}.conf" ]]; then
    pass "pacman.${arch}.conf exists"
  else
    warn "pacman.${arch}.conf not found (optional)"
  fi
done

# 5. Check CI/CD configs
check "Checking CI/CD configurations..."
[[ -d ".github/workflows" ]] && pass ".github/workflows directory exists" || fail ".github/workflows not found"
[[ -f ".github/workflows/build.yml" ]] && pass "GitHub Actions build.yml exists" || warn "GitHub Actions build.yml not found"
[[ -f ".github/workflows/monitor-upstream.yml" ]] && pass "GitHub Actions monitor-upstream.yml exists" || warn "monitor-upstream.yml not found"
[[ -f ".gitlab-ci.yml" ]] && pass "GitLab CI config exists" || warn ".gitlab-ci.yml not found"

# 6. Check documentation
check "Checking documentation..."
[[ -f "README.md" ]] && pass "README.md exists" || warn "README.md not found"
[[ -f "docs/AUTOBUILD.md" ]] && pass "AUTOBUILD.md exists" || warn "AUTOBUILD.md not found"
[[ -f "docs/RELEASE-GUIDE.md" ]] && pass "RELEASE-GUIDE.md exists" || warn "RELEASE-GUIDE.md not found"

# 7. Check airootfs structure
check "Checking airootfs structure..."
[[ -d "airootfs" ]] && pass "airootfs directory exists" || fail "airootfs not found"
[[ -d "airootfs/etc" ]] && pass "airootfs/etc exists" || fail "airootfs/etc not found"
[[ -d "airootfs/usr" ]] && pass "airootfs/usr exists" || fail "airootfs/usr not found"

# 8. Validate package list syntax
check "Validating package list syntax..."
if [[ -f "packages.x86_64" ]]; then
  # Check for common errors
  if grep -q "^$" "packages.x86_64" 2>/dev/null; then
    warn "Empty lines found in packages.x86_64 (usually OK)"
  fi
  
  # Count packages (basic validation)
  pkg_count=$(grep -c "^[a-zA-Z0-9]" "packages.x86_64" || true)
  pass "Found ~$pkg_count package entries"
fi

# 9. Validate MATE packages presence
check "Validating MATE desktop packages..."
if grep -q "^mate$" "packages.x86_64"; then
  pass "MATE core package present"
else
  fail "MATE core package NOT found in packages.x86_64"
fi

if grep -q "^marco$" "packages.x86_64"; then
  pass "MATE window manager (marco) present"
else
  warn "MATE window manager (marco) not found"
fi

if grep -q "^caja$" "packages.x86_64"; then
  pass "MATE file manager (caja) present"
else
  warn "MATE file manager (caja) not found"
fi

if grep -q "^brisk-menu$" "packages.x86_64"; then
  pass "Modern menu (brisk-menu) present"
else
  warn "brisk-menu not found (optional)"
fi

# 10. Check for conflicting packages
check "Checking for conflicting Cinnamon packages..."
CONFLICTS=0
for pkg in "cinnamon" "muffin" "nemo" "cinnamon-control-center"; do
  if grep -q "^${pkg}$" "packages.x86_64"; then
    fail "CONFLICT: Found Cinnamon package '$pkg' in MATE build!"
  fi
done
pass "No Cinnamon packages found (good!)"

# 11. Validate GitHub Actions workflows
check "Validating GitHub Actions workflows..."
if [[ -f ".github/workflows/build.yml" ]]; then
  if grep -q "ubuntu-latest" ".github/workflows/build.yml"; then
    pass "GitHub Actions uses ubuntu-latest runner"
  fi
  
  if grep -q "schedule:" ".github/workflows/build.yml"; then
    pass "Schedule trigger configured"
  fi
  
  if grep -q "workflow_dispatch:" ".github/workflows/build.yml"; then
    pass "Manual trigger (workflow_dispatch) configured"
  fi
fi

# 12. Check build script permissions
check "Checking build script permissions..."
for script in "build-mate.sh" "generate-build-info.sh" "mkarchiso_wrapper"; do
  if [[ -f "$script" ]]; then
    if [[ -x "$script" ]]; then
      pass "$script is executable"
    else
      warn "$script is NOT executable (will cause issues)"
      chmod +x "$script"
      pass "Fixed: $script is now executable"
    fi
  fi
done

# 13. Check for common issues
check "Checking for common issues..."

if [[ ! -d "work" ]]; then
  pass "No stale 'work' directory found"
else
  warn "Found 'work' directory from previous build (can be safely deleted)"
fi

if [[ ! -d "../ISO" ]]; then
  pass "No output directory (will be created during build)"
else
  pass "Output directory exists"
  iso_count=$(find ../ISO -name "*.iso" 2>/dev/null | wc -l || true)
  if [[ $iso_count -gt 0 ]]; then
    warn "Found $iso_count existing ISO files"
  fi
fi

# 14. Summary
echo ""
echo "=========================================="
echo "✅ Validation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review any warnings above"
echo "2. Run: SKIP_TERMS=1 ./build-mate.sh x86_64"
echo "3. Wait 30-60 minutes for build to complete"
echo "4. ISO will be in ../ISO/ directory"
echo ""
