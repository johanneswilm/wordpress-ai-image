# GitHub Actions Workflows

This directory contains automated workflows for the AI Image Marker WordPress plugin.

## Available Workflows

### 1. Release (`release.yml`)

**Trigger**: When a new tag is pushed (e.g., `v1.0.0`)

**Purpose**: Automatically creates a GitHub release with the plugin ZIP file

**What it does**:
- Compiles translations (.po → .mo)
- Creates plugin ZIP file
- Creates GitHub release
- Attaches ZIP to release
- Generates release notes

**Usage**:
```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0

# GitHub will automatically:
# 1. Build the plugin
# 2. Create a release using GitHub CLI
# 3. Attach ai-image-marker-1.0.0.zip
```

**Release Contents**:
- Plugin ZIP file: `ai-image-marker-{version}.zip`
- Automatic release notes
- Link to CHANGELOG.md
- Installation instructions

### 2. Build Test (`build-test.yml`)

**Trigger**: On pull requests and pushes to `main` or `develop` branches

**Purpose**: Verify the plugin builds correctly

**What it does**:
- Compiles translations
- Runs build script
- Verifies ZIP contents
- Checks for essential files
- Uploads build artifact

**Checks performed**:
- ✓ Build script executes without errors
- ✓ ZIP file is created
- ✓ ai-image-marker.php is present
- ✓ admin.js is present
- ✓ LICENSE is present
- ✓ README.md is present
- ✓ CHANGELOG.md is present
- ✓ Compiled translations are present

**Artifacts**:
- Build artifacts are kept for 7 days
- Can be downloaded from Actions tab

## Creating a Release

### Step-by-Step Process

1. **Update version** in `ai-image-marker/ai-image-marker.php`:
   ```php
   * Version: 1.1.0
   ```

2. **Update CHANGELOG** in `ai-image-marker/CHANGELOG.md`:
   ```markdown
   ## [1.1.0] - 2025-01-21
   
   ### Added
   - New feature description
   
   ### Fixed
   - Bug fix description
   ```

3. **Commit changes**:
   ```bash
   git add .
   git commit -m "Prepare v1.1.0 release"
   git push
   ```

4. **Create and push tag**:
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```

5. **Wait for workflow**: GitHub Actions will automatically:
   - Build the plugin
   - Create release
   - Attach ZIP file

6. **Verify release**: Go to GitHub → Releases to see your new release

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- `v1.0.0` - Major release (breaking changes)
- `v1.1.0` - Minor release (new features)
- `v1.0.1` - Patch release (bug fixes)

## Workflow Requirements

### Secrets

No additional secrets needed! Workflows use the built-in `GITHUB_TOKEN`.

### Permissions

The release workflow requires explicit permissions:
```yaml
permissions:
  contents: write  # Required for creating releases
```

This is defined in the workflow file.

### Dependencies

Workflows install required tools automatically:
- `gettext` - For compiling translations
- `zip` - For creating archives (pre-installed)

## Monitoring Workflows

### View Workflow Runs

1. Go to your repository on GitHub
2. Click **Actions** tab
3. See all workflow runs

### Check Build Status

Build status badges can be added to README.md:

```markdown
![Build Test](https://github.com/username/repo/actions/workflows/build-test.yml/badge.svg)
![Release](https://github.com/username/repo/actions/workflows/release.yml/badge.svg)
```

## Troubleshooting

### Build Fails

**Check**:
- Is `build.sh` executable? (`chmod +x build.sh`)
- Are translation files valid?
- Does the build work locally? (`./build.sh`)

**Logs**: Click on failed workflow run → Click on failed step

### Release Not Created

**Check**:
- Tag format: Must be `v*` (e.g., `v1.0.0`, not `1.0.0`)
- Tag pushed to remote: `git push origin v1.0.0`
- Workflow triggered: Check Actions tab
- Permissions: Workflow has `contents: write` permission

**Common issues**:
- Forgot to push tag
- Wrong tag format
- Permissions issue (fixed in workflow with explicit permissions)

**If "Resource not accessible by integration" error**:
- This was fixed by using GitHub CLI instead of deprecated actions
- Make sure workflow has `permissions: contents: write`

### Translation Not Compiled

**Check**:
- `.po` file exists
- `.po` file is valid
- No syntax errors in translation file

**Test locally**:
```bash
cd ai-image-marker/languages
msgfmt -c ai-image-marker-nb_NO.po
```

## Customization

### Change Workflow Behavior

Edit the workflow files:
- `.github/workflows/release.yml` - Release process
- `.github/workflows/build-test.yml` - Build testing

### Add More Checks

In `build-test.yml`, add steps like:
- PHP syntax checking
- JavaScript linting
- WordPress coding standards
- Unit tests

Example:
```yaml
- name: Check PHP syntax
  run: find ai-image-marker -name "*.php" -exec php -l {} \;

- name: WordPress Coding Standards
  run: phpcs --standard=WordPress ai-image-marker/
```

## Best Practices

### Before Releasing

1. ✓ Test plugin locally
2. ✓ Update version number
3. ✓ Update CHANGELOG.md
4. ✓ Commit all changes
5. ✓ Create tag
6. ✓ Push tag

### After Releasing

1. ✓ Verify release on GitHub
2. ✓ Download and test ZIP
3. ✓ Test installation in WordPress
4. ✓ Update documentation if needed

## Manual Release (Fallback)

If workflows fail, you can create releases manually:

```bash
# Build locally
./build.sh

# Create release on GitHub
gh release create v1.0.0 \
  release/ai-image-marker-1.0.0.zip \
  --title "AI Image Marker v1.0.0" \
  --notes "See CHANGELOG.md for details"
```

## Advanced Usage

### Pre-release Versions

For beta/RC versions:

```bash
git tag v1.1.0-beta.1
git push origin v1.1.0-beta.1
```

Modify `release.yml` to mark as pre-release:
```yaml
prerelease: ${{ contains(github.ref, 'beta') || contains(github.ref, 'rc') }}
```

### Auto-deploy to WordPress.org

For WordPress.org plugin repository, add a workflow that:
1. Builds the plugin
2. Checks out WordPress.org SVN
3. Commits to SVN trunk
4. Tags release in SVN

## Recent Fixes

### GitHub Actions v1.0.1 Update

**Issue**: The original workflow used deprecated actions (`actions/create-release@v1` and `actions/upload-release-asset@v1`) which caused permission errors.

**Fix**: Updated to use GitHub CLI (`gh release create`) which is:
- Actively maintained
- Works with modern GitHub permissions
- Simpler (one command instead of two actions)
- More reliable

**Changes**:
- Replaced `actions/create-release@v1` with `gh release create`
- Added explicit `permissions: contents: write`
- Combined release creation and asset upload in single step

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [WordPress Plugin Guidelines](https://developer.wordpress.org/plugins/wordpress-org/detailed-plugin-guidelines/)

## Support

If you encounter issues with workflows:

1. Check workflow logs in Actions tab
2. Verify build works locally
3. Review this documentation
4. Check GitHub Actions status page
5. Open an issue in the repository