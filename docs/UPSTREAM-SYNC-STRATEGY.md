# Upstream Package Sync Strategy

## Overview

This document defines the strategy for safely syncing package updates from upstream AcreetionOS while maintaining MATE desktop integrity.

## Package Classification

### Category A: Safe to Sync (65 packages)
Core system packages that work identically with both Cinnamon and MATE:

```
# System Core
base, linux, linux-headers, linux-firmware, sudo, dbus, polkit
systemd, systemd-sysvcompat, mkinitcpio, mkinitcpio-archiso

# Boot & EFI
grub, syslinux, efibootmgr, intel-ucode, amd-ucode, pxelinux

# Graphics (X11 + Mesa - both DEs use this)
xorg, xorg-server, xorg-xinit, xorg-xkill
mesa, mesa-utils, glu, vulkan-*

# Input Devices
xf86-input-libinput, xf86-input-evdev

# GPU Drivers (used by both Cinnamon and MATE)
xf86-video-amdgpu, xf86-video-intel, xf86-video-nouveau
xf86-video-qxl, xf86-video-vmware, xf86-video-vesa

# Networking
networkmanager, network-manager-applet, nm-connection-editor
openssh, curl, wget, dhcpcd, wpa_supplicant, iwd
bluez, bluez-utils

# Audio (PipeWire works with both)
pipewire, pipewire-audio, pipewire-pulse, wireplumber
alsa-utils, pavucontrol, pamixer

# Display Manager (LightDM works with both)
lightdm, lightdm-gtk-greeter

# Core Utilities
nano, vim, zsh, tmux, git, rsync, util-linux
filesystem, tzdata, locale

# System Monitoring
htop, btop, fastfetch, inxi

# Installation
calamares, calamares-config, archinstall

# Compression & Archives
bzip2, gzip, xz, zstd, p7zip, tar

# Development
base-devel, gcc, make, cmake, python, rustup, nodejs

# Libraries (shared by both)
gtk2, gtk3, qt5-base, qt6-base
glib, glib-networking, gnutls, openssl

# Icon/Theme Support
papirus-icon-theme, arc-gtk-theme, adwaita-icon-theme

# Cloud & Virtualization
cloud-init, open-vm-tools, qemu-guest-agent
virtualbox-guest-utils-nox
```

**Sync Strategy**: ✅ AUTO-SYNC (Safe)
- Check for updates monthly
- Auto-apply minor versions
- Review major versions before applying

---

### Category B: Evaluate for Sync (20 packages)
Packages with minimal desktop environment interaction:

```
# New Core Libraries (check compatibility)
glib-networking, gnutls, yaml-cpp, libpwquality

# New Utilities
polkit-gnome, diffutils, fakeroot, autologin, fastfetch

# Security Updates
linux-atm, vulkan-headers, opencl-headers, directx-headers

# Firmware
linux-firmware-marvell, linux-firmware-qlogic, linux-firmware-whence

# Boot/Init
mkinitcpio-busybox, mkinitcpio-nfs-utils, mkinitcpio-openswap
mkinitcpio-systemd-tool
```

**Sync Strategy**: ⚠️ MANUAL REVIEW
- Test locally first
- Check for conflicts with MATE
- Document changes before merging
- One-by-one or small batches

---

### Category C: NEVER Sync (75 packages)
Packages that break MATE desktop or duplicate functionality:

#### Cinnamon & Dependencies (CONFLICT)
```
cinnamon, cinnamon-control-center, cinnamon-menus
cinnamon-session, cinnamon-screensaver, cinnamon-desktop
cinnamon-applets, cinnamon-extensions
muffin, cjs, cinnamon-polkit
```

#### GNOME & Dependencies (CONFLICT)
```
gnome-terminal, gnome-keyring, gnome-keyring-daemon
gnome-themes-extra, gnome-shell, gnome-session
gnome-desktop, gnome-settings-daemon
evolution, evolution-data-server, evolution-source-extension
gnome-video-effects, gnome-wallpapers
```

#### Portal Conflict
```
xdg-desktop-portal-xapp          # Cinnamon-specific
# MATE uses: xdg-desktop-portal-gtk (already present)
```

#### File Manager Conflict
```
nemo                             # Cinnamon file manager
# MATE uses: caja (already present)
```

#### Display Manager Alternative
```
gdm                              # GNOME display manager
# MATE uses: lightdm (already present)
```

#### Noto Fonts (Duplicates)
```
noto-fonts-*, fonts-noto-*
# Arc theme already handles typography
```

#### Session Managers
```
gnome-session                    # Conflicts with mate-session
```

#### Desktop Integration
```
xdg-desktop-portal-gnome         # Conflicts with xdg-desktop-portal-gtk
glib2-docs, gtk-doc              # Documentation (not needed)
```

**Sync Strategy**: ❌ NEVER MERGE
- These create package conflicts
- Break MATE desktop functionality
- Remove desktop integration
- Consume extra disk space

**Exception Process**:
- If needed, create separate GNOME variant branch
- Maintain MATE as primary
- Test thoroughly in isolated container

---

## Sync Workflow

### Monthly Sync Process (Step-by-Step)

**Phase 1: Preparation (10 minutes)**
```bash
# Create tracking branch
git checkout -b sync/upstream-packages-$(date +%Y%m)

# Clone upstream temporarily
git clone --depth=1 https://github.com/acreetionos-code/acreetionos.git /tmp/upstream
```

**Phase 2: Analysis (15 minutes)**
```bash
# Compare packages
diff -u packages.x86_64 /tmp/upstream/packages.x86_64 > /tmp/packages.diff

# Categorize changes
# A: Lines removed (verify safe to remove)
# B: Lines added (check Category B rules)
# C: Lines changed (version updates - category A)
```

**Phase 3: Cherry-Pick (20 minutes)**
```bash
# Apply Category A changes (auto)
# Example:
patch -p1 < /tmp/category-a.patch

# Manually review Category B changes
# One-by-one: grep "^+" /tmp/packages.diff | grep -v "^+++"

# Verify Category C removals
# Check Category C don't appear in diff
grep -E "cinnamon|gnome-terminal|nemo|muffin" /tmp/packages.diff || echo "Good: No conflicts"
```

**Phase 4: Testing (45 minutes)**
```bash
# Build locally
SKIP_TERMS=1 ./build-mate.sh x86_64

# Test ISO boots
qemu-system-x86_64 -boot d -cdrom ../ISO/AcreetionOS-MATE-*.iso

# Verify MATE still works
# - Login works
# - Desktop appears
# - File manager opens (caja)
# - Control center opens
# - Applications menu (brisk-menu) works
```

**Phase 5: Commit (5 minutes)**
```bash
# Create informative commit
git add packages.x86_64
git commit -m "sync: update packages from upstream $(date +%Y-%m)

- Added: [List any new packages]
- Removed: [List obsolete packages]
- Updated: [List version changes]
- Verified: MATE desktop functional, no conflicts
- Tested: ISO boots BIOS+UEFI

Ref: upstream/acreetionos commit: [hash]"

# Push for review
git push origin sync/upstream-packages-$(date +%Y%m)
```

**Phase 6: Release (if approved)**
```bash
# Merge to main
git checkout main
git merge --ff-only sync/upstream-packages-$(date +%Y%m)

# Tag for release
git tag -a v1.1-mate.1 -m "MATE 1.1 sync from upstream"

# Push
git push origin main v1.1-mate.1
# (GitHub Actions auto-builds and releases)
```

---

## Conflict Resolution

### Scenario 1: Upstream removes a Category A package
**Action**: Remove from MATE too
```bash
# Example: upstream removes zenity
git diff /tmp/upstream/packages.x86_64 | grep "^-zenity"
# Remove zenity from MATE packages.x86_64
```

### Scenario 2: Upstream adds a Cinnamon package
**Action**: Skip (preserve MATE focus)
```bash
# Example: upstream adds cinnamon-applets
grep "cinnamon-applets" /tmp/upstream/packages.x86_64
# Don't add to MATE - intentional difference
```

### Scenario 3: Upstream changes a Category B package
**Action**: Evaluate and test
```bash
# Example: upstream updates gnutls
# Test: git checkout /tmp/upstream/packages.x86_64
# Build: ./build-mate.sh x86_64
# Verify: No regressions
```

### Scenario 4: Version conflict
**Action**: Use MATE's tested version
```bash
# Example: upstream uses newer kernel
# Check: maturity and AUR feedback
# Decide: adopt or maintain current version
```

---

## Automated Monitoring

### GitHub Actions Workflow
The `.github/workflows/monitor-upstream.yml` automatically:
1. Checks upstream every 12 hours
2. Downloads latest `packages.x86_64`
3. Diffs with MATE version
4. Posts summary as PR comment
5. Flags conflicts/updates

**Manual review still required before merging.**

---

## Version Tagging Strategy

When syncing upstream versions:

```
Format: v{upstream-version}-mate.{release-number}

Examples:
v1.0-mate.1          # First MATE release from upstream 1.0
v1.0-mate.2          # Second release (sync update)
v1.1-mate.1          # Sync to new upstream 1.1
```

---

## Rollback Procedure

If sync causes issues:

```bash
# Revert last commit
git revert HEAD

# Or reset to previous version
git checkout v1.0-mate.1 -- packages.x86_64

# Test
./build-mate.sh x86_64

# Force push (if not yet merged)
git push origin sync/branch --force

# Or create new tag
git tag v1.0-mate.1-fixed
```

---

## Documentation Requirements

Every sync must include:

1. **Changelog Entry** (CHANGELOG.md)
   ```markdown
   ## v1.1-mate.1 (2026-04-15)
   - Synced upstream packages (upstream v1.1)
   - Added: linux-headers update to 6.x.x
   - Removed: deprecated package-x
   - Fixed: [specific issues if any]
   ```

2. **Commit Message** (as shown above)

3. **Release Notes** (GitHub/GitLab)
   ```markdown
   ### Packages Updated
   - [list of changes]
   
   ### Testing
   - [verification done]
   
   ### Known Issues
   - [if any]
   ```

---

## Frequency & Schedule

- **Daily**: Automated monitoring
- **Weekly**: Review monitoring results
- **Monthly**: Execute sync process
- **As-needed**: Emergency security patches
- **Per-release**: Upstream sync (typically monthly)

---

## Success Criteria

✅ Sync is successful when:
1. No package conflicts (no cinnamon/gnome in final list)
2. MATE desktop boots and functions
3. All three boot modes work (BIOS, UEFI32, UEFI64)
4. File manager, control center, menu work
5. Test ISO size is ~750MB ±50MB
6. Build completes in <60 minutes

❌ Sync should be rolled back if:
1. Build fails
2. MATE desktop won't start
3. Package conflicts detected
4. Boot fails on any mode
5. Critical functionality missing

---

## References

- **Upstream**: https://github.com/acreetionos-code/acreetionos
- **MATE Desktop**: https://mate-desktop.org
- **Arch Package Search**: https://archlinux.org/packages
- **AUR**: https://aur.archlinux.org

---

**Last Updated**: 2026-03-29
**Next Review**: 2026-04-29
