# Feature Set Cross-Comparison: Cinnamon vs. Lite (MATE)

This document provides a comparative analysis of the feature sets between the flagship Cinnamon edition and the newly optimized AcreetionOS Lite (MATE).

| Feature / Component | Cinnamon (Flagship) | Lite (MATE Edition) | Status | Notes |
|---------------------|----------------------|---------------------|---------|-------|
| **Core Desktop** | Cinnamon 6.x | MATE 1.28+ | **Implemented** | Lite uses MATE for 1-core/2GB RAM targets. |
| **Window Manager** | Muffin (Mutter-based) | Marco | **Implemented** | Lite: Compositing disabled for performance. |
| **Application Menu** | Cinnamon Menu | Brisk Menu | **Implemented** | Both feature searchable, modern menus. |
| **Panel / Taskbar** | Cinnamon Panel | MATE Panel | **Implemented** | Lite: Single bottom 36px panel. |
| **File Manager** | Nemo | Caja | **Implemented** | Caja is lighter but functionally similar. |
| **Terminal** | Gnome Terminal / Cosmic | MATE Terminal | **Implemented** | MATE Terminal is lighter on RAM. |
| **Text Editor** | Xed / Gedit | Pluma | **Implemented** | Pluma is the classic Lite standard. |
| **System Settings** | Cinnamon Settings | MATE Control Center | **Implemented** | Centralized config UI present in both. |
| **Visual Effects** | Full Compositing/Shadows | Disabled / Basic | **Implemented** | Lite favors speed over transparency. |
| **Animations** | Smooth / Transition-heavy | Disabled (Fast) | **Implemented** | Lite disabled for instant UI response. |
| **Memory Opts** | Standard Swap | zRAM + earlyoom | **Implemented** | Lite: Optimized for 2GB systems. |
| **App Pre-caching** | None (Default) | Preload | **Implemented** | Lite: Speeds up 1-core CPU execution. |
| **Package GUI** | Pamac / Update Manager | Pamac-GTK | **Implemented** | User-friendly GUI maintained in both. |
| **Icon Theme** | Papirus-Dark / Cosmic | Papirus-Dark | **Implemented** | Identical iconography for brand consistency. |
| **GTK Theme** | Acreetion-Dark / Orchis | Arc-Dark | **Implemented** | Arc-Dark chosen for low-overhead performance. |
| **Bluetooth** | Blueberry / Bluez | Blueman | **Implemented** | Blueman is more robust for Lite environments. |
| **Installer** | Calamares | Calamares | **Implemented** | Branded "Lite" for the MATE version. |

## Feature Completeness Summary

- **Desktop Experience**: 100% Implemented (Lite components chosen to match flagship layout).
- **Performance Layer**: 100% Implemented (zRAM, earlyoom, preload, no-animations).
- **Branding Consistency**: 100% Implemented (Wallpaper, Icons, LightDM, Plymouth, Grub).
- **Tooling**: 100% Implemented (Pamac, Caja, Pluma, Brisk).

AcreetionOS Lite successfully delivers the signature user experience with significant under-the-hood reductions in CPU and memory usage.
