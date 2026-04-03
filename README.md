# AcreetionOS Linux Number 1
# copyright 2025
Welcome to AcreetionOS Linux, an open-source project aimed at providing the user a stable and up-to-date experience.

Download ISO here: https://acreetionos.org

## Project Overview

AcreetionOS Linux is a community-driven effort to build a lightweight, versatile Linux distribution. AcreetionOS Linux is currently based on Arch Linux, but the future goal is to be a parallel* distribution with our own base. Our goal is to provide a solid foundation for both everyday users and developers, with a focus on simplicity, ease of use, and stability; all while keeping packages up to date.

For a detailed look at our recent technical enhancements and performance optimizations, see [IMPROVEMENTS.md](./IMPROVEMENTS.md).

## Features

- Lightweight base system
- Standardized Package Selection
- User-friendly installation process
- x86_64, i686, ARM (aarch64/armv7h), and RISC-V support.

## Multi-Architecture Support

AcreetionOS Lite now supports multiple architectures:
- **x86_64** (64-bit PC)
- **i686** (32-bit PC)
- **aarch64** (ARM64, e.g., Raspberry Pi 4)
- **armv7h** (ARM32)
- **riscv64** (RISC-V)

### Building for a Specific Architecture

To build for a specific architecture, pass the architecture as an argument to `build-mate.sh`:

```bash
# Build for x86_64 (Default)
./build-mate.sh x86_64

# Build for ARM64
./build-mate.sh aarch64

# Build for 32-bit x86
./build-mate.sh i686

# Build for RISC-V
./build-mate.sh riscv64
```

Note: Building for non-native architectures requires `qemu-user-static` and `binfmt-support` installed and configured on the build host.

## Getting Started

To get started with AcreetionOS Linux, you can:

1. Download the latest ISO from our [Website](https://acreetionos.org)!
2. Create a bootable USB drive using tools like [Etcher]("https://etcher.balena.io/#download-etcher"), [Rufus]("https://rufus.ie/en/"), or [Ventoy]("https://ventoy.net/en/index.html").
3. Boot from the USB drive and follow the installation instructions

*     Ventoy MUST use GRUB MODE 2, if you use grub by its self will not boot correctly if at all.*
## Contributing

We welcome contributions from the community! Please see our [Contributing Guide](https://github.com/AcreetionOS/acreetionos-mate/blob/main/docs/AUTOBUILD.md) file for guidelines on how to get involved.

## Roadmap

Our current goal is to release a stable distribution by the end of 2026. Check out our [project status](./PROJECT_STATUS.txt) and [Phase 8 readiness assessment](./PHASE8-READINESS.md) for more details on upcoming features and milestones.

## Project Information

- **Project Status:** In active development
- **License:** MIT
- **Maintainers:** Darren Clift (@cobra3282000), Johnathan Spiva (@sprunglesongithub) or (@Sprungles)


## Contact

For questions, suggestions, or support, please [open an issue](https://github.com/AcreetionOS/acreetionos-mate/issues) on our GitHub repository.

Thank you for your interest in AcreetionOS Linux!


## Definitions:

*Parallel Distribution: A distribution similar to, but having a different goal and future goal set.
