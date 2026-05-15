# AcreetionOS MATE Release Guide

## Release Checklist

### Pre-Release (1-2 days before)
- [ ] Sync with upstream AcreetionOS latest changes
- [ ] Review and merge any pending PRs
- [ ] Update CHANGELOG.md with new version details
- [ ] Test build locally: `SKIP_TERMS=1 ./build-mate.sh x86_64`
- [ ] Verify ISO boots in both BIOS and UEFI modes
- [ ] Validate checksums match
- [ ] Update version number in `profiledef.sh` if needed
- [ ] Create release notes document

### Release Day (Create & Tag)

**Step 1: Prepare Commit**
```bash
git pull origin main
git status  # Ensure clean working directory
```

**Step 2: Create Version Tag**
```bash
# Version format: v{upstream-version}-mate.{release-number}
# Examples: v1.0-mate.1, v1.0-mate.2, v1.1-mate.1

VERSION="v1.0-mate.1"
git tag -a "${VERSION}" -m "AcreetionOS MATE Edition ${VERSION}"

# Verify tag
git show "${VERSION}"

# Push tag
git push origin "${VERSION}"
```

**Step 3: GitHub Actions Triggers**
- GitHub Actions automatically detects the tag
- Build workflow starts automatically
- Creates GitHub Release with ISO attachment
- Generates checksums automatically

**Release branch protection**
- Direct pushes to `release-*` branches must have an annotated tag on `HEAD` matching `vX.Y-mate.N` or `vX.Y.Z-mate.N`.
- Require the `Release Branch Guard` workflow as a protected branch status check to block untagged pushes.

**Step 4: GitLab CI Triggers** (if using GitLab)
- GitLab CI automatically detects the tag
- Build and release stages run automatically
- Creates GitLab Release with assets

### Post-Release (After builds complete)

**Step 1: Verify Releases Created**

GitHub:
1. Go to repository → Releases
2. Confirm new release appears
3. Verify ISO and checksums are attached
4. Confirm file sizes match expected ~600MB range

GitLab (if applicable):
1. Go to repository → Releases
2. Confirm new release appears
3. Verify assets are included

**Step 2: Announce Release**

```bash
# Get ISO details for announcement
cd ../ISO
ls -lh AcreetionOS-MATE-*.iso
cat AcreetionOS-MATE-*.iso.sha256
```

Announcement template:
```
🎉 **AcreetionOS MATE Edition v1.0-mate.1 Released!**

New features:
- [List key updates from upstream sync]
- [MATE-specific improvements]
- [Performance optimizations]

📥 Download: [GitHub Release Link]
🔐 SHA256: [Hash]

Join our Discord: https://discord.gg/JTuQs4M5WD
```

**Step 3: Update Documentation**
- Update README.md with new version info
- Update website download links
- Update installation documentation if needed

## Semantic Versioning

```
Format: {upstream-version}-mate.{release-number}

Components:
├── upstream-version    : AcreetionOS upstream version (1.0, 1.1, etc.)
├── -mate               : Indicates MATE variant
└── release-number      : This MATE release number for that upstream version

Examples:
v1.0-mate.1            # First MATE release based on AcreetionOS 1.0
v1.0-mate.2            # Second release (bug fix, security patch)
v1.1-mate.1            # First MATE release based on AcreetionOS 1.1
```

## Build Failures During Release

If the automated build fails:

**GitHub Actions:**
1. Go to Actions tab
2. Click on the failed workflow
3. View logs for error details
4. Common issues:
   - Disk space: Clean with `sudo rm -rf work/`
   - Network: Retry build from Actions UI
   - Pacman: Check upstream for package availability

**Manual Recovery:**
```bash
# Build locally to debug
SKIP_TERMS=1 ARCH=x86_64 ./build-mate.sh

# Create release manually
gh release create v1.0-mate.1 ../ISO/AcreetionOS-MATE-*.iso --notes "Release notes here"
```

## Maintenance Release Process

For maintenance releases (security patches, critical bugs):

1. Checkout main branch: `git checkout main`
2. Apply fix/update: `git commit -am "Security fix: ..."`
3. Create release tag: `git tag -a v1.0-mate.2`
4. Push: `git push origin main && git push origin v1.0-mate.2`
5. Automated release follows

## Nightly Builds

Scheduled nightly builds run automatically:
- **When**: Every Sunday at 00:00 UTC
- **Version**: `nightly-YYYYMMDD`
- **Artifacts**: 30-day retention
- **Purpose**: Continuous integration testing

To download nightly builds:
1. GitHub: Actions tab → Latest scheduled workflow → Download artifacts
2. GitLab: Pipelines → Latest scheduled run → Artifacts

## Release Metadata

Each release includes:

```
AcreetionOS-MATE-{VERSION}-{ARCH}.iso         # Main ISO (typically 600-800MB)
AcreetionOS-MATE-{VERSION}-{ARCH}.iso.sha256  # SHA256 checksum
AcreetionOS-MATE-{VERSION}-{ARCH}.iso.md5     # MD5 checksum
BUILD_REPORT.txt                                # Build details
```

Verify downloads:
```bash
sha256sum -c AcreetionOS-MATE-*.iso.sha256
md5sum -c AcreetionOS-MATE-*.iso.md5
```

## Version Increment Strategy

### Major Version Bump (e.g., 1.0 → 2.0)
- Upstream major version change
- Or significant architectural changes
- Example: v2.0-mate.1

### Minor Version Bump (e.g., 1.0 → 1.1)
- Upstream minor version change
- Or new major features in MATE variant
- Example: v1.1-mate.1

### Patch Release (e.g., mate.1 → mate.2)
- Security updates
- Bug fixes
- Dependency updates
- Example: v1.0-mate.2

## Emergency Release Process

For critical security or data loss issues:

1. **Create hotfix branch**: `git checkout -b hotfix/critical-issue`
2. **Apply fix**: Make and test changes
3. **Commit**: `git commit -am "CRITICAL: Fix XYZ"`
4. **Tag immediately**: `git tag -a v1.0-mate.1-hotfix`
5. **Announce widely**: Email, Discord, social media
6. **Merge back**: Merge hotfix to main after verification

## Release Communication

### Channels
- **GitHub Releases**: Auto-populated from tag annotations
- **Discord**: `#announcements` channel
- **Email**: developers@acreetionos.org
- **Website**: Update download links at acreetionos.org
- **Social Media**: Twitter/X, Mastodon (if applicable)

### Release Notes Template
```markdown
# AcreetionOS MATE v{VERSION}

## What's New

### Features
- [Feature 1]
- [Feature 2]
- [Feature 3]

### Improvements
- [Improvement 1]
- [Improvement 2]

### Fixes
- [Fix 1]
- [Fix 2]

### Packages Updated
- Package1 x.y.z → x.y.z+1
- Package2 a.b.c → a.b.c+1

## Downloads

- **SHA256**: [checksum]
- **Size**: ~750 MB
- **Build Date**: YYYY-MM-DD

## Installation

See [Installation Guide](link-to-guide)

## Known Issues

- [Known issue 1 and workaround]
- [Known issue 2 and workaround]

## Credits

- Upstream: AcreetionOS team
- MATE variant: Natalie Spiva, Darren Clift, Contributors
```

## Rollback Procedure

If a release has critical issues:

1. **GitHub**: Delete release and tag
   ```bash
   gh release delete v1.0-mate.1
   git push origin --delete v1.0-mate.1
   ```

2. **GitLab**: Archive/delete release from UI

3. **Announce**: Post issue notice immediately

4. **Fix**: Create hotfix and re-release

5. **Tag as `-broken`**: Keep tag for reference
   ```bash
   git tag -d v1.0-mate.1
   git tag v1.0-mate.1-broken
   git push origin v1.0-mate.1-broken
   ```

## Statistics Tracking

Track releases for insights:
```bash
# Count releases
gh release list | wc -l

# Get download counts (GitHub API)
curl https://api.github.com/repos/{owner}/{repo}/releases | jq '.[] | {tag_name, assets: .assets[0]}'

# Check release dates
git tag -l --format='%(refname:short) %(creatordate:short)'
```

## Next Release Schedule

- **Regular**: Every upstream release (typically monthly)
- **Maintenance**: As needed for patches/security
- **Nightly**: Every Sunday 00:00 UTC (automatic)

---

**For questions**: Contact developers@acreetionos.org or Discord
