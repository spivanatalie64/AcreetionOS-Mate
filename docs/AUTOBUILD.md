# AcreetionOS MATE Autobuild Documentation

## Overview

This repository contains automated build infrastructure for **AcreetionOS MATE Edition**, a lightweight, MATE-based variant of AcreetionOS. The autobuild system triggers automatically when upstream AcreetionOS releases new versions and runs on a weekly schedule.

## Build Triggers

The ISO is automatically built in these scenarios:

### 1. **Upstream Release Detection** (Recommended)
- Monitors `https://github.com/acreetionos-code/acreetionos` for new releases
- Automatically syncs package updates
- Triggers a new MATE build
- Publishes ISO to GitHub/GitLab Releases

### 2. **Scheduled Builds** (Weekly)
- Runs every Sunday at 00:00 UTC
- Ensures regular builds even if upstream is inactive
- Creates `nightly-YYYYMMDD` versioned ISOs

### 3. **Manual Builds** (On-Demand)
- Use `workflow_dispatch` in GitHub Actions
- Use `web` trigger in GitLab CI
- Useful for testing or emergency builds

## Architecture

### Supported Platforms
- **Architectures**: x86_64 (primary focus)
- **Future**: aarch64, armv7h, i686, riscv64 (infrastructure ready)

### Build System Components

```
┌─────────────────────────────────┐
│ Upstream AcreetionOS            │
│ (github.com/acreetionos-code)   │
└────────────────┬────────────────┘
                 │
        ┌────────▼────────┐
        │ Release Monitor │
        │ (.github/monitor-upstream.yml)
        └────────┬────────┘
                 │
        ┌────────▼──────────────────┐
        │ GitHub Actions & GitLab CI │
        │ Build Pipelines           │
        └────────┬──────────────────┘
                 │
        ┌────────▼──────────────────┐
        │ ISO Build Execution       │
        │ (build-mate.sh)           │
        └────────┬──────────────────┘
                 │
        ┌────────▼──────────────────┐
        │ Release Artifact Creation  │
        │ (GitHub & GitLab)         │
        └────────┬──────────────────┘
                 │
        ┌────────▼──────────────────┐
        │ Download ISO + Checksums  │
        │ From GitHub/GitLab        │
        └───────────────────────────┘
```

## Directory Structure

```
acreetionos-mate/
├── .github/
│   └── workflows/
│       ├── build.yml              # Main build workflow
│       └── monitor-upstream.yml   # Upstream monitoring
├── .gitlab-ci.yml                 # GitLab CI pipeline
├── build-mate.sh                  # Build script (enhanced)
├── generate-build-info.sh         # Build metadata generator
├── profiledef.sh                  # archiso profile
├── packages.x86_64                # Package list (MATE)
├── pacman.x86_64.conf             # Pacman configuration
├── airootfs/                      # Filesystem overlay
│   └── etc/
│       └── acreetion-build-info   # Build metadata (auto-generated)
└── docs/
    └── AUTOBUILD.md               # This file
```

## CI/CD Configuration

### GitHub Actions (`.github/workflows/build.yml`)

**Triggers:**
- Scheduled: `0 0 * * 0` (Weekly Sunday at 00:00 UTC)
- Repository dispatch: `upstream-release` event
- Manual: `workflow_dispatch`

**Jobs:**
- `build`: Builds ISO for each architecture (matrix)
  - Outputs to: `../ISO/AcreetionOS-MATE-*.iso`
  - Artifacts: 30-day retention
  - Release: Auto-created for tags

**Artifacts:**
```
AcreetionOS-MATE-${VERSION}-${ARCH}.iso
AcreetionOS-MATE-${VERSION}-${ARCH}.iso.sha256
```

### GitLab CI (`.gitlab-ci.yml`)

**Stages:**
1. `build`: Compile ISO
2. `release`: Create GitLab Release

**Variables:**
- `ARCH`: x86_64 (configurable)
- `CI_COMMIT_MESSAGE`: Passed from CI
- `FF_USE_FASTZIP`: true (compression optimization)

**Artifacts:**
- Path: `../ISO/`
- Expires: 30 days
- Includes checksums

## Build Scripts

### `build-mate.sh` (Main Build Script)

Enhanced build script with CI/CD support:

```bash
# Manual build (interactive)
./build-mate.sh x86_64

# CI/CD build (non-interactive)
SKIP_TERMS=1 ./build-mate.sh x86_64

# Custom output directory
OUTPUT_DIR=/path/to/output SKIP_TERMS=1 ./build-mate.sh x86_64
```

**Features:**
- ✅ Colored output for better readability
- ✅ Comprehensive error handling
- ✅ Build logging to `build-${ARCH}-${TIMESTAMP}.log`
- ✅ Automatic checksum generation (SHA256, MD5)
- ✅ Build report generation
- ✅ Multi-architecture support (ready)
- ✅ CI/CD environment detection

**Environment Variables:**
- `SKIP_TERMS`: Set to 1 to skip license confirmation
- `ARCH`: Architecture (x86_64, aarch64, i686, etc.)
- `OUTPUT_DIR`: Custom ISO output directory
- `BUILD_SYSTEM`: Build system identifier (used in metadata)

### `generate-build-info.sh` (Metadata Generator)

Generates build metadata stored in `airootfs/etc/acreetion-build-info`:

```
EDITION=AcreetionOS-MATE
VERSION=1.0-mate.42
BUILD_SERIAL=MATE-A1B2C3D4
ARCHITECTURE=x86_64
GIT_COMMIT=abc1234
GIT_BRANCH=main
BUILD_DATE=2026-03-29 22:10:00 UTC
BUILD_USER=natalie2
BUILD_SYSTEM=GitHub Actions
```

This metadata is embedded in the ISO and available after boot.

## Package Management

### MATE Desktop Components

All MATE desktop components are pre-configured:

```
mate                    # Core MATE metapackage
mate-extra              # Extended utilities
marco                   # Window manager
caja                    # File manager
mate-terminal           # Terminal emulator
mate-control-center     # Settings
brisk-menu              # Modern menu (Cinnamon-style UX)
lightdm                 # Display manager
```

### Syncing with Upstream

Package changes from upstream AcreetionOS are automatically reviewed:

1. **Monitor Workflow**: Checks upstream `packages.x86_64` weekly
2. **Comparison**: Diffs upstream vs. local packages
3. **Merge Strategy**: 
   - Auto-sync non-DE packages
   - Manual review for DE packages
   - MATE packages never replaced

**To manually sync packages:**

```bash
# Clone upstream
git clone --depth=1 https://github.com/acreetionos-code/acreetionos.git /tmp/upstream

# Review differences
diff packages.x86_64 /tmp/upstream/packages.x86_64

# Apply specific updates manually
# (Never auto-merge to preserve MATE configuration)
```

## Release Management

### Versioning Scheme

```
Format: {upstream-version}-mate.{build-number}

Examples:
- 1.0-mate.1          # First MATE release from upstream 1.0
- 1.0-mate.2          # Second build (e.g., bug fix)
- 1.1-mate.1          # New upstream version
- nightly-20260329    # Scheduled nightly build
```

### Creating Releases

**GitHub Releases:**
1. Tag: `git tag -a v1.0-mate -m "AcreetionOS MATE 1.0"`
2. Push: `git push origin v1.0-mate`
3. GitHub Actions automatically:
   - Builds ISO
   - Creates release
   - Uploads ISO + checksums

**GitLab Releases:**
1. Tag: `git tag -a v1.0-mate -m "AcreetionOS MATE 1.0"`
2. Push: `git push origin v1.0-mate`
3. GitLab CI automatically:
   - Builds ISO
   - Creates release
   - Uploads to GitLab

### Artifact Retention

- **GitHub**: 30 days for artifacts, indefinite for releases
- **GitLab**: 30 days for build artifacts, indefinite for releases

## Testing Builds

### Local Testing

```bash
# Build locally
SKIP_TERMS=1 ./build-mate.sh x86_64

# Verify checksum
sha256sum -c ../ISO/AcreetionOS-MATE-*.iso.sha256

# Boot in QEMU (test BIOS)
qemu-system-x86_64 -boot d -cdrom ../ISO/AcreetionOS-MATE-*.iso

# Boot in QEMU (test UEFI)
qemu-system-x86_64 -bios /usr/share/OVMF/OVMF_CODE.fd -boot d -cdrom ../ISO/AcreetionOS-MATE-*.iso
```

### CI/CD Testing

**GitHub Actions:**
- Logs: Available in Actions tab after workflow completion
- Download: Click on build artifacts to download ISO

**GitLab CI:**
- Logs: Available in Pipelines → Jobs
- Download: Artifacts section in job details

## Troubleshooting

### Build Failures

**GitHub Actions Logs:**
1. Go to repository → Actions tab
2. Click failed workflow run
3. Click job and view logs

**GitLab CI Logs:**
1. Go to repository → CI/CD → Pipelines
2. Click pipeline run number
3. Click job and view logs

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| ISO not found | Build failed | Check logs for pacman/archiso errors |
| Checksum mismatch | Corrupted download | Re-download and verify |
| Boot fails | BIOS/UEFI mismatch | Test both boot modes |
| Out of space | Full disk | Clean work directory: `sudo rm -rf work/` |
| Permission denied | Missing sudo | Ensure sudo is available in CI environment |

### Manual Build Debug

```bash
# Enable verbose output
set -x

# Run build with logging
BUILD_SYSTEM="debug" SKIP_TERMS=1 ./build-mate.sh x86_64 2>&1 | tee debug.log

# Check build metadata
cat airootfs/etc/acreetion-build-info
```

## Maintenance

### Weekly Tasks
- Monitor upstream releases for critical updates
- Review build logs for warnings
- Check artifact storage usage

### Monthly Tasks
- Verify downloads still work from releases
- Update documentation as needed
- Clean up old artifact versions

### Per-Release Tasks
- Test ISO boots correctly (BIOS + UEFI)
- Verify checksums
- Create release notes
- Announce on Discord/social media

## Contribution Guidelines

### Modifying Build Configuration

1. **Create a branch**: `git checkout -b feature/improve-build`
2. **Test locally**: `SKIP_TERMS=1 ./build-mate.sh x86_64`
3. **Commit changes**: `git commit -am "Improve build system"`
4. **Push and create PR**: `git push origin feature/improve-build`
5. **CI checks**: GitHub Actions + GitLab CI automatically test

### Package Updates

- Edit `packages.x86_64` for package additions/removals
- Test build locally before pushing
- Document breaking changes in commit message
- Reference upstream changes with link to their commit

### Workflow Updates

- Edit `.github/workflows/*.yml` for GitHub Actions changes
- Edit `.gitlab-ci.yml` for GitLab CI changes
- Test in fork before merge
- Document new features in this file

## Resources

- **AcreetionOS**: https://github.com/acreetionos-code/acreetionos
- **AcreetionOS Website**: https://acreetionos.org
- **Discord Community**: https://discord.gg/JTuQs4M5WD
- **archiso Documentation**: https://wiki.archlinux.org/title/Archiso
- **GitHub Actions**: https://docs.github.com/en/actions
- **GitLab CI**: https://docs.gitlab.com/ee/ci/

## License

This project is licensed under GPL-3.0, same as AcreetionOS.

See LICENSE file for details.

---

**Last Updated**: 2026-03-29
**Maintained By**: AcreetionOS MATE Edition Team
