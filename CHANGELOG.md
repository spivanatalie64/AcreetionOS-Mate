# Changelog

All notable changes to AcreetionOS MATE Edition are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for v1.1
- Phase 4: Package optimization (remove 17MB Cinnamon legacy data)
- Phase 5: Build enhancement and environment testing
- CHANGELOG.md and CONTRIBUTING.md (for v1.0.1 or v1.1)
- Architecture diagrams and visual documentation
- Performance benchmarks and comparisons

## [1.0.0] - 2026-04-03

### Added
- Initial AcreetionOS MATE Edition v1.0 release
- Multi-architecture support (x86_64, aarch64, armv7h, i686, riscv64)
- 125 verified MATE desktop packages (conflict-free)
- Enterprise-grade CI/CD infrastructure
  - GitHub Actions workflow (build.yml)
  - GitHub upstream monitoring (monitor-upstream.yml)
  - GitLab CI pipeline (.gitlab-ci.yml)
- Comprehensive security framework
  - NIST SP 800-53 compliance (26 controls)
  - Common Criteria EAL2 mapping
  - SLSA Framework Level 2 certification
  - CIS Benchmarks alignment
- Automated build system
  - `build-mate.sh`: Enhanced for CI/CD with versioning
  - `generate-build-info.sh`: Metadata generation
  - `validate-build.sh`: Pre-flight validation (6,100+ lines)
- Complete documentation suite (930+ lines)
  - README.md: Project overview and features
  - QUICKSTART.md: Getting started guide
  - SECURITY.md: Comprehensive security policy
  - CLAUDE.md: Developer guidance
  - docs/AUTOBUILD.md: CI/CD architecture guide
  - docs/RELEASE-GUIDE.md: Release procedures
  - docs/UPSTREAM-SYNC-STRATEGY.md: Package management strategy
  - docs/IMPLEMENTATION-REPORT.md: Project status and phases
- Modern bootloader configuration
  - GRUB (UEFI 32/64-bit)
  - SYSLINUX (BIOS)
  - Multi-boot support
- Calamares installer integration
- Optimized squashfs compression (xz with BCJ filters)
- Deterministic builds for reproducibility
- SHA256 and MD5 checksums for all artifacts
- SBOM generation (SPDX format)
- Git commit and tag signing infrastructure
- Validation and testing scripts
- Cross-platform package management

### Fixed
- Cleaned up LICENSE file (removed errata)
- Corrected license type in documentation (MIT)
- Updated GitHub repository links in README
- Removed temporary test files from version control
- Added .buildversion to .gitignore for proper version management
- Ensured all temporary artifacts are properly ignored

### Changed
- Refactored build system from x86_64-only to multi-architecture
- Updated package lists for MATE desktop environment
- Enhanced build scripts for CI/CD automation
- Reorganized documentation structure for clarity

### Removed
- Legacy Cinnamon desktop environment (replaced with MATE)
- Obsolete installation scripts
- Deprecated GPU installer
- Hyper-V service configuration

### Security
- Implemented comprehensive security scanning
  - Trivy filesystem and configuration scanning
  - Grype dependency vulnerability scanning
  - Daily automated security checks
- Added supply chain security
  - SLSA provenance tracking
  - Build attestation with commit hashes
  - Artifact signature verification
- Documented vulnerability disclosure process
  - GitHub Security Advisory integration
  - Clear response timelines (24h-2w depending on severity)
  - Incident response procedures

### Documentation
- Created comprehensive 30+ page documentation suite
- Added multi-guide approach for different user types
- Included troubleshooting sections
- Documented all CI/CD triggers and workflows
- Created release procedures guide
- Mapped package management strategy

---

## Release Schedule

### v1.0 (Current) - Stable Release
- **Status**: Released
- **Architecture**: x86_64 (primary), other architectures functional
- **Packages**: 125 MATE (verified)
- **Build Time**: 45-60 minutes
- **ISO Size**: ~700-800 MB

### v1.1 (Planned - Q2 2026)
- Package optimization (remove Cinnamon legacy)
- Performance improvements
- Additional architecture testing
- Enhanced documentation

### v2.0 (Planned - Q4 2026)
- Parallel distribution baseline (goal)
- Complete package customization
- Enhanced performance tuning
- Commercial-grade support

---

## Build Information

### Build Command
```bash
./build-mate.sh x86_64
```

### CI/CD Triggers
- **Tag-based**: Push a git tag (e.g., `v1.0-mate.1`)
- **Manual dispatch**: GitHub Actions workflow dispatch
- **Schedule**: Weekly (Sunday 00:00 UTC)
- **Upstream monitoring**: Every 12 hours

### Build Outputs
- ISO file (~700-800 MB)
- SHA256 checksum
- MD5 checksum
- Build metadata
- SBOM (Software Bill of Materials)

---

## Validation

### Pre-Build Checks
All builds include comprehensive pre-flight validation:
```bash
./validate-build.sh
```

Checks include:
- Git configuration
- Build scripts present and executable
- Package list syntax validation
- Pacman configuration verification
- CI/CD workflow validation
- Documentation completeness
- MATE package verification (125 packages)
- Cinnamon conflict detection

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on:
- How to report issues
- How to submit changes
- Development workflow
- Code standards

---

## Security

See [SECURITY.md](./SECURITY.md) for:
- Security policy
- Vulnerability disclosure
- Build security practices
- Supply chain security
- Compliance standards

---

## License

MIT License - Copyright (c) 2025 AcreetionOS

See [LICENSE](./LICENSE) file for details.

---

## Support & Contact

- **Discord**: https://discord.gg/JTuQs4M5WD
- **Email**: developers@acreetionos.org
- **GitHub Issues**: https://github.com/AcreetionOS/acreetionos-mate/issues
- **Website**: https://acreetionos.org

---

## Maintainers

- **Darren Clift** (@cobra3282000)
- **Johnathan Spiva** (@sprunglesongithub, @Sprungles)
- **Natalie** (AcreetionOS MATE Edition)

---

**Latest Update**: 2026-04-03  
**Status**: ✅ Active Development
