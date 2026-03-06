# AcreetionOS Project Map (Lite Edition)

This document provides a comprehensive overview of the AcreetionOS project structure, focusing on the "Lite" edition optimized for low-resource hardware (1-core CPU, 2GB RAM).

## 📂 Root Directory Structure

- **`airootfs/`**: The root filesystem overlay for the live ISO. Contains all system-wide and user-specific customizations.
- **`calamares-config-source/`**: Configuration for the [Calamares](https://github.com/AcreetionOS-Code/calamares-config.git) installer, branded for AcreetionOS Lite.
- **`efiboot/`**: Bootloader configuration and EFI binaries for UEFI systems.
- **`grub/`**: GRUB bootloader configuration and the Acreetion galaxy theme.
- **`syslinux/`**: Syslinux configuration for BIOS/Legacy systems.
- **`packages.x86_64`**: The master list of packages, optimized to include MATE and performance tools while excluding heavy Cinnamon dependencies.
- **`profiledef.sh`**: The main configuration file for `mkarchiso`, defining "AcreetionOS-Lite" metadata and file permissions.
- **`pacman.conf`**: Custom pacman configuration including AcreetionOS official and community (ACUR) repositories.
- **`docs/CHANGES_LITE.md`**: Detailed log of optimizations and transitions for the Lite edition.

---

## 🖥️ Desktop Environment: AcreetionOS Lite (MATE)

The project uses a highly optimized **MATE Desktop** to provide a modern, "Cinnamon-like" experience on a fraction of the resources.

### Performance Optimizations (Lite Focus)

| Feature | Component | Purpose |
|---------|-----------|---------|
| Memory Swap | `zram-generator` | Uses compressed RAM for swap, doubling effective memory on 2GB systems. |
| OOM Protection | `earlyoom` | Prevents system lockups by killing runaway processes before RAM is exhausted. |
| App Pre-caching | `preload` | Speeds up application launch times on single-core CPUs. |
| Graphics Load | `Marco (no composite)` | Disables window shadows/transparency to save CPU/GPU cycles. |
| Responsiveness | `No Animations` | Disables UI animations for a snappier feel on low-power hardware. |

### Key Configuration Mapping

| Component | Path | Description |
|-----------|------|-------------|
| System Dconf | `airootfs/mate_settings.dconf` | Master settings for themes, layout, and performance (no animations). |
| Live User Dconf | `airootfs/mate.dconf` | Applied to the live session to ensure immediate "Acreetion Look." |
| Home Configs | `airootfs/mate-configs/` | Skeleton configs copied to the installed user's home directory. |
| File Manager | `caja` | Lightweight alternative to Nemo. |
| App Menu | `brisk-menu` | Search-centric menu mirroring the Cinnamon experience. |

---

## 🛠️ Build & Installation Logic

### Package Management (`packages.x86_64`)
The package list has been pruned of Cinnamon/GNOME overhead. It now includes `mate`, `mate-extra`, `brisk-menu`, and performance daemons (`earlyoom`, `preload`, `zram-generator`).

### Calamares Configuration (`calamares-config-source/`)
The installer is branded "Lite" and configured to:
- Set up the MATE session as the default.
- Install optimized software selections (e.g., Pluma instead of Gedit).
- Apply the Lite edition's branding during the "Welcome" and "Finished" screens.

---

## 📝 Architectural Notes

1. **Lite Philosophy:** Features are maintained (Web, Media, Office) but delivered via lighter components (MATE vs Cinnamon) and backed by memory-saving kernel tunables.
2. **Overlay Application:** Desktop settings are strictly managed via `dconf` to ensure consistency between the live ISO and the final installed system.
3. **Hardware Compatibility:** Includes drivers for NVIDIA, AMD, and Intel to ensure the Lite edition runs on a wide variety of legacy hardware.
