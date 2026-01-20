# Release v1.0.1 Checklist

## ✅ Pre-Release (Completed)

- [x] Version updated in `ai-image-marker/ai-image-marker.php` (1.0.1)
- [x] Version constant updated (`const VERSION = '1.0.1'`)
- [x] CHANGELOG.md updated with v1.0.1 changes
- [x] .gitignore fixed to ignore ZIP files
- [x] Old ZIP removed from Git tracking
- [x] Local build successful (`./build.sh`)
- [x] ZIP created: `release/ai-image-marker-1.0.1.zip`

## 📝 Changes in v1.0.1

### New Features
- Block Editor (Gutenberg) support
- Featured image AI notices (single post/page views only)
- AI notices on images without captions

### Improvements
- AI notice floats to the right
- Notice appears above caption text
- Better text wrapping around notice
- Consistent styling across all contexts

### Technical
- Added `render_block` filter for Block Editor
- Added `post_thumbnail_html` filter for featured images
- Enhanced CSS for various contexts
- Responsive design improvements

## 🚀 Release Steps

### 1. Final Review
```bash
# Review all changes
git status
git diff

# Test locally if possible
# - Upload to local WordPress
# - Test Block Editor images
# - Test featured images
# - Test Classic Editor
```

### 2. Commit Changes
```bash
# Stage all changes
git add .gitignore
git add ai-image-marker/
git add .github/
git add CONTRIBUTING.md
git add README.md

# Commit
git commit -m "Release v1.0.1 - Block Editor support and featured images"

# Push to main
git push origin main
```

### 3. Create and Push Tag
```bash
# Create tag
git tag -a v1.0.1 -m "Version 1.0.1 - Block Editor support and featured images"

# Push tag (triggers GitHub Actions)
git push origin v1.0.1
```

### 4. Monitor GitHub Actions
- Go to repository → Actions tab
- Watch the "Create Release" workflow
- Should complete in ~2 minutes
- Verify no errors

### 5. Verify Release
- Go to repository → Releases
- Check v1.0.1 release was created
- Verify `ai-image-marker-1.0.1.zip` is attached
- Review release notes

### 6. Test the Release
- Download the ZIP from GitHub release
- Upload to a test WordPress site
- Test all features:
  - [ ] Mark image as AI-generated
  - [ ] Block Editor image shows notice
  - [ ] Classic Editor image shows notice
  - [ ] Featured image shows notice on single post
  - [ ] Featured image doesn't show on archives
  - [ ] Notice floats right correctly
  - [ ] Norwegian translation works

## 📋 Post-Release

### Documentation
- [ ] Update main README if needed
- [ ] Announce in relevant channels (if applicable)
- [ ] Close related issues/PRs

### WordPress.org (if applicable)
- [ ] Update WordPress.org plugin repository
- [ ] Update screenshots if needed
- [ ] Update readme.txt

## 🐛 Rollback Plan (if needed)

If something goes wrong:

```bash
# Delete the tag locally
git tag -d v1.0.1

# Delete the tag remotely
git push origin :refs/tags/v1.0.1

# Delete the GitHub release (via web interface)

# Fix issues and try again
```

## 📊 Success Criteria

- [x] Version 1.0.1 code complete
- [ ] Git tag v1.0.1 pushed
- [ ] GitHub Actions completed successfully
- [ ] GitHub release created
- [ ] ZIP file attached to release
- [ ] Release notes generated
- [ ] Plugin tested and working

## 🎉 Ready to Release!

Run these commands:

```bash
git add .
git commit -m "Release v1.0.1 - Block Editor support and featured images"
git push origin main
git tag v1.0.1
git push origin v1.0.1
```

Then watch GitHub Actions do the rest!
