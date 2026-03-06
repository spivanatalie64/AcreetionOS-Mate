# AcreetionOS Lite Changes

This document outlines the major changes and optimizations made to the AcreetionOS Lite edition (formerly MATE edition).

## Core Identity
- **Name Change**: Rebranded from AcreetionOS MATE to **AcreetionOS Lite**.
- **Target Hardware**: Optimized for single-core CPUs and 2GB RAM systems.
- **Desktop Environment**: MATE Desktop, configured to match the look and feel of the Cinnamon flagship edition.

## Performance Optimizations
- **Memory Management**:
    - Added `zram-generator`: Configured to use half of RAM as compressed swap (zram), significantly improving performance on 2GB systems.
    - Added `earlyoom`: Userspace Out-Of-Memory killer to prevent system freezes during high memory pressure.
    - Set `vm.swappiness=100` to prioritize compressed swap over disk I/O.
- **Application Loading**:
    - Added `preload`: Background daemon that monitors frequently used applications and pre-caches them into memory.
- **Visual Optimizations**:
    - Disabled **Marco Compositing**: Reduces CPU/GPU load for window management.
    - Disabled **Animations**: Global interface and panel animations turned off for snappier response on slow cores.
    - **Reduced Resources**: Enabled MATE's reduced-resources mode in Marco.

## Desktop Experience
- **Panel Layout**: Single bottom panel (36px) featuring:
    - **Brisk Menu**: Modern, searchable menu similar to Cinnamon.
    - **Window List**: Standard taskbar for window management.
    - **System Tray**: For network, volume, and power indicators.
- **Theming**:
    - **GTK Theme**: Arc-Dark
    - **Icon Theme**: Papirus-Dark
    - **Wallpaper**: Official AcreetionOS galaxy background (`acreetion.png`).
- **File Manager**: Caja (MATE native) configured with a clean layout.
- **Software Management**: Enabled `pamac-gtk3` for a user-friendly GUI.

## System Configuration
- **Login Screen**: LightDM GTK Greeter configured with Arc-Dark theme and AcreetionOS wallpaper.
- **Branding**: Updated `os-release` and Calamares installer branding to reflect the Lite edition.
- **Bootloader**: Plymouth boot splash set to `acreetion` theme.
