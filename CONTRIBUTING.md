# Contributing to AcreetionOS MATE

Thank you for your interest in contributing to AcreetionOS MATE Edition! This guide will help you get started with the development process.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Coding Standards](#coding-standards)
5. [Submitting Changes](#submitting-changes)
6. [Reporting Issues](#reporting-issues)
7. [Release Process](#release-process)
8. [Questions?](#questions)

---

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please:

- Be respectful and constructive in all interactions
- Welcome and support other contributors
- Report behavior violations to developers@acreetionos.org
- Focus on the code, not the person

---

## Getting Started

### Prerequisites

Before you start, ensure you have:

```bash
# Git (version control)
sudo pacman -S git

# Build essentials
sudo pacman -S base-devel

# For local builds
sudo pacman -S archiso

# For validation
sudo pacman -S shellcheck
```

### Fork and Clone

1. **Fork** the repository on GitHub/GitLab
   - Visit: https://github.com/AcreetionOS/acreetionos-mate
   - Click "Fork" button

2. **Clone** your fork locally
   ```bash
   git clone https://github.com/YOUR-USERNAME/acreetionos-mate.git
   cd acreetionos-mate
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/AcreetionOS/acreetionos-mate.git
   git fetch upstream
   ```

### Set Up Git Configuration

```bash
# Configure your name and email (required for commits)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Recommended: Configure GPG signing for commits
git config user.signingkey YOUR-GPG-KEY-ID
git config commit.gpgSign true
```

### Install Development Tools

```bash
# Recommended shell analysis
sudo pacman -S shellcheck

# Optional: Pre-commit hooks for validation
pip install pre-commit
```

---

## Development Workflow

### 1. Create a Feature Branch

Always create a new branch for your work:

```bash
# Update main first
git checkout main
git pull upstream main

# Create feature branch (use descriptive name)
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
# or
git checkout -b docs/documentation-improvement
```

### 2. Branch Naming Convention

Use one of these prefixes:

- **feature/** - New functionality
- **fix/** - Bug fixes
- **docs/** - Documentation updates
- **test/** - Test additions/improvements
- **refactor/** - Code reorganization
- **perf/** - Performance improvements
- **ci/** - CI/CD changes
- **security/** - Security fixes

Examples:
- `feature/package-optimization`
- `fix/build-script-error`
- `docs/quickstart-update`
- `security/dependency-update`

### 3. Make Your Changes

```bash
# Edit files as needed
nano packages.x86_64
# or
vim build-mate.sh

# Test your changes
./validate-build.sh

# For shell scripts, use shellcheck
shellcheck build-mate.sh
```

### 4. Commit Your Work

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "feat: Add MATE package optimization

- Remove 17MB Cinnamon legacy data
- Add 20 verified upstream packages
- Improve startup time by 2.5%

Fixes #42
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 6. Submit a Pull Request

1. Go to your fork on GitHub
2. Click "Compare & pull request"
3. Fill in the PR template:
   - **Title**: Brief description of changes
   - **Description**: Detailed explanation and motivation
   - **Type**: Feature, Fix, Docs, etc.
   - **Testing**: How you tested the change
   - **Related Issues**: Link any related issues (#42)

---

## Coding Standards

### Shell Scripts

All shell scripts should follow these standards:

```bash
#!/usr/bin/env bash

# Use strict mode
set -euo pipefail

# Meaningful variable names (snake_case)
build_dir="$(pwd)"

# Use quotes for variables
echo "Build directory: $build_dir"

# Use [[ ]] instead of [ ]
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# Use functions for reusable code
log_info() {
    echo "ℹ️  $*"
}

log_info "Script started"
```

**Standards to follow:**

- Use `#!/usr/bin/env bash` shebang
- Enable `set -euo pipefail` for safety
- Use meaningful variable names
- Quote all variables: `"$var"`
- Use `[[ ]]` for conditionals, not `[ ]`
- Add helpful comments
- Keep functions focused and small
- Use shellcheck: `shellcheck script.sh`

### Package Lists

When modifying `packages.x86_64` or related files:

```bash
# Good: Organized with comments
#===============================================================================
# 1. CORE SYSTEM
#===============================================================================
base
linux
linux-headers

#===============================================================================
# 2. DESKTOP ENVIRONMENT (MATE)
#===============================================================================
mate-desktop
mate-terminal
caja
```

**Standards:**

- Organize by category
- Add comments above sections
- One package per line
- Alphabetically ordered within sections
- No duplicates

### Configuration Files

For `profiledef.sh` and similar:

```bash
# Clear variable naming
iso_name="AcreetionOS-MATE"
iso_label="acreetionos_mate_$(date +%Y%m)"

# Meaningful comments for complex logic
bootmodes=(
  'bios.syslinux.mbr'           # BIOS boot
  'uefi-x64.grub.esp'           # UEFI 64-bit
  'uefi-ia32.grub.esp'          # UEFI 32-bit
)
```

### Documentation

For markdown files:

- Use proper heading hierarchy (# → ## → ###)
- Include table of contents for long documents
- Add code examples where appropriate
- Keep line length reasonable (~80 chars)
- Use clear, active voice
- Include links to related docs

---

## Submitting Changes

### Before Submitting

1. **Run validation**
   ```bash
   ./validate-build.sh
   ```

2. **Test your changes**
   ```bash
   # For build system changes
   SKIP_TERMS=1 ./build-mate.sh x86_64
   
   # For documentation
   # Review the rendered markdown
   ```

3. **Check shell scripts**
   ```bash
   shellcheck build-mate.sh generate-build-info.sh
   ```

4. **Review your changes**
   ```bash
   git diff upstream/main
   ```

### Creating a Pull Request

**Good PR checklist:**

- [ ] Branch created from latest `main`
- [ ] Clear, descriptive commit message
- [ ] Changes tested locally
- [ ] Shell scripts pass shellcheck
- [ ] `./validate-build.sh` passes
- [ ] Documentation updated (if applicable)
- [ ] License headers included (if required)
- [ ] No merge conflicts
- [ ] Related issues linked

**PR Title Format:**

```
[TYPE] Brief description

Examples:
- [FEATURE] Add MATE package optimization
- [FIX] Correct build script error in line 45
- [DOCS] Update QUICKSTART.md with new commands
- [CI] Improve GitHub Actions workflow
```

**PR Description Template:**

```markdown
## Description
Brief explanation of what and why.

## Motivation
Why is this change needed?

## Changes
- Changed X to Y
- Added Z
- Removed W

## Testing
How did you test this?
- Ran `./validate-build.sh`
- Local build succeeded

## Checklist
- [ ] Code follows standards
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No breaking changes
```

---

## Reporting Issues

### Before Reporting

1. **Check existing issues**: https://github.com/AcreetionOS/acreetionos-mate/issues
2. **Search documentation**: Check QUICKSTART.md and docs/
3. **Try the workaround**: If documented, test it

### Creating an Issue

Use the appropriate issue template:

**Bug Report:**
```markdown
## Description
Clear description of the bug.

## Steps to Reproduce
1. Run command X
2. Observe Y
3. Expected Z

## Environment
- OS: (output of `uname -a`)
- Build command used
- Relevant error messages

## Logs
Attach relevant build logs
```

**Feature Request:**
```markdown
## Description
What would you like to add?

## Motivation
Why do you need this?

## Proposed Solution
How should it work?

## Alternatives
Other approaches considered?
```

### Issue Labels

Issues are tagged with:
- **bug**: Something is broken
- **feature**: New functionality request
- **documentation**: Doc improvements needed
- **question**: Help or clarification
- **good-first-issue**: Great for newcomers
- **help-wanted**: Need community input
- **blocked**: Waiting on something else

---

## Release Process

### Version Numbering

We follow Semantic Versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (rare)
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes only

Example: `1.0.0` → `1.1.0` → `1.1.1` → `2.0.0`

### Creating a Release

1. **Update version** in relevant files
   ```bash
   # Update PROJECT_STATUS.txt, PHASE files, etc.
   ```

2. **Update CHANGELOG.md**
   ```markdown
   ## [1.1.0] - 2026-05-15
   ### Added
   - New feature X
   
   ### Fixed
   - Bug Y
   ```

3. **Create a tag**
   ```bash
   git tag -a v1.1.0 -m "AcreetionOS MATE v1.1.0 Release"
   ```

4. **Push the tag**
   ```bash
   git push upstream v1.1.0
   ```

5. **GitHub Actions** will automatically:
   - Build the ISO
   - Generate checksums
   - Create a GitHub Release
   - Upload artifacts

See [docs/RELEASE-GUIDE.md](./docs/RELEASE-GUIDE.md) for detailed procedures.

---

## Testing

### Running Validation

Before committing:

```bash
./validate-build.sh
```

This checks:
- ✓ Git configuration
- ✓ Build scripts executable
- ✓ Package list syntax
- ✓ Pacman configuration
- ✓ CI/CD workflows
- ✓ Documentation
- ✓ MATE package verification

### Local Build Testing

For significant changes:

```bash
# Full build (non-interactive for CI)
SKIP_TERMS=1 ./build-mate.sh x86_64

# Check output
ls -lh ../ISO/AcreetionOS-MATE-*.iso
```

### Shell Script Testing

```bash
# Check for common issues
shellcheck build-mate.sh
shellcheck generate-build-info.sh
shellcheck validate-build.sh

# Manual testing
bash -n build-mate.sh  # Syntax check
```

---

## Documentation

### Updating Docs

When updating documentation:

1. Make changes to `.md` files
2. Preview locally (if possible)
3. Update table of contents if needed
4. Link to related docs
5. Run `./validate-build.sh` to check formatting

### Adding New Documentation

1. Create file in appropriate location
   - General docs: `docs/`
   - User guide: Root level (README, QUICKSTART, etc.)
   - Security: SECURITY.md

2. Add to table of contents or index

3. Link from relevant files

4. Ensure consistent style with existing docs

---

## Questions?

### Getting Help

- **Discord**: https://discord.gg/JTuQs4M5WD
- **Email**: developers@acreetionos.org
- **GitHub Discussions**: Create a discussion
- **GitHub Issues**: Ask in issues (tag with 'question')

### Contribution Process Questions

Ask on Discord in #development channel or email developers@acreetionos.org

### Technical Questions

Open a GitHub issue with the 'question' label

---

## Recognition

Contributors will be recognized:

- In git commit history
- In GitHub contributors section
- In release notes (for significant contributions)
- On project website (for major contributions)

---

## License

By contributing to AcreetionOS MATE, you agree that your contributions will be licensed under the MIT License. See [LICENSE](./LICENSE) file.

---

## Summary

1. **Fork and clone** the repository
2. **Create a feature branch** with descriptive name
3. **Make your changes** following coding standards
4. **Test your changes** (`./validate-build.sh`)
5. **Commit with clear messages** (including Co-authored-by trailer)
6. **Push to your fork** and submit a **pull request**
7. **Respond to feedback** and iterate

We appreciate your contribution! Thank you for helping make AcreetionOS MATE better. 🚀

---

**Last Updated**: 2026-04-03  
**Status**: ✅ Active (Ready for contributions)
