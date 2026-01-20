# Changelog

All notable changes to the AI Image Marker project will be documented in this file.

This is the single changelog for both the plugin and the repository.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-01-20

### Plugin - Added
- Featured image support - AI notices now appear on featured images in single post/page views
- Featured images display AI notice below the image (only on singular views, not archives)
- Added `post_thumbnail_html` filter to process featured images

### Plugin - Fixed
- Block Editor (Gutenberg) support - AI notices now appear on images inserted via Block Editor
- AI notices display on images both with and without captions in Block Editor
- Added `render_block` filter to process `core/image` blocks

### Plugin - Changed
- AI notice now floats to the right side of captions
- AI notice appears above/before caption text (not after)
- Notice positioned directly under bottom-right of image
- Improved styling with proper text flow around the notice
- Works consistently in both Block Editor and Classic Editor

---

## [1.0.0] - 2025-01-20

### Plugin - Added
- Initial release of AI Image Marker WordPress plugin
- Checkbox in media library attachment details to mark images as AI-generated
- Automatic display of "Generated with artificial intelligence" notice on frontend
- Custom column in media library list view showing AI-generated status
- Quick Edit support for bulk operations in media library
- Helper functions for theme developers:
  - `is_ai_generated_image($attachment_id)` - Check if image is AI-generated
  - `get_ai_image_notice($attachment_id)` - Get HTML notice for AI images
- Full internationalization support with WordPress i18n system
- Complete Norwegian Bokmål (nb_NO) translation
- Translation template file (POT) for adding additional languages
- CSS classes added to AI-generated images:
  - `.ai-generated-image` - Added to `<img>` elements
  - `.ai-generated-caption` - Added to captions containing AI images
  - `.ai-generated-notice` - The notice text element
- Data attribute `data-ai-generated="true"` for JavaScript integration
- Inline CSS styles for basic notice formatting
- Admin JavaScript for Quick Edit functionality
- Integration with WordPress caption shortcode system
- Media library grid and list view support
- Documentation files:
  - README.md - Complete user and developer documentation
  - INSTALL.md - Detailed installation and troubleshooting guide
  - QUICKSTART.md - 5-minute quick start guide
  - EXAMPLES.md - 15+ code examples for developers
  - PROJECT_OVERVIEW.md - Technical architecture overview
  - CHANGELOG.md - This file


### Repository - Added
- Automated build system with `build.sh` script
- Makefile with development commands (`make build`, `make verify`, etc.)
- GitHub Actions workflows:
  - `release.yml` - Automatic ZIP creation and GitHub releases on tags
  - `build-test.yml` - Automated build testing on PRs and pushes
  - Automatic translation compilation in CI/CD
  - Build artifact uploads for testing
- Comprehensive documentation structure:
  - Root README.md - Project overview and build instructions
  - CONTRIBUTING.md - Developer contribution guidelines
  - PROJECT_OVERVIEW.md - Technical architecture documentation
  - QUICK_REFERENCE.md - Command quick reference
  - FILE_STRUCTURE.md - File organization explanation
  - BUILD_SUMMARY.txt - Build system summary
  - `.github/workflows/README.md` - GitHub Actions documentation
- Git repository configuration with `.gitignore`
- `release/` directory for build outputs
- Complete Norwegian Bokmål (nb_NO) translation
- Translation compilation integrated into build process

### Technical Details
- Meta key `_ai_generated_image` stores AI-generated flag in postmeta
- No external dependencies or API calls
- GPL v2 or later license
- Compatible with WordPress 5.0+
- Requires PHP 7.0+

### Supported Languages
- English (en) - Default
- Norwegian Bokmål (nb_NO) - Complete translation

---

## [Unreleased]

### In Progress
- Testing Block Editor integration across different themes
- Feedback on emoji vs text-only AI notices

### Repository Commands
```bash
# Build plugin
./build.sh
make build

# Development
make dev-install WP_PATH=/path/to/wordpress
make translations
make clean
make verify

# Information
make version
make help
```

---

## Future Plans

### Plugin Features
- Bulk actions support in media library
- Settings page for customizing notice text
- Optional AI image watermarking
- REST API endpoint extensions
- Block editor (Gutenberg) sidebar integration
- WooCommerce integration enhancements
- Usage statistics and analytics
- Export/import AI image lists
- Custom post type support beyond attachments


### Repository Enhancements
- CI/CD pipeline (GitHub Actions)
- Automated testing
- WordPress.org SVN integration
- Release automation
- Code quality checks (PHP_CodeSniffer, ESLint)

---

## Version History

- **1.0.1** - Block Editor support, featured images, improved styling (January 2025)
- **1.0.0** - Initial public release (January 2025)

---

## Upgrade Notice

### 1.0.1
Adds Block Editor support, featured image notices, and improved styling. All AI-marked images now display notices in Block Editor, Classic Editor, and as featured images on single post/page views.

### 1.0.0
First release of AI Image Marker. Provides simple marking and display of AI-generated images in WordPress media library. Includes complete build system and development tools.

---

## Notes

### For Plugin Users
This plugin stores AI-generated status in WordPress database as post metadata. Uninstalling the plugin will not automatically remove this data, allowing you to preserve your markings if you reinstall later.

### For Developers
This repository uses a two-level structure:
- Root directory: Development tools and documentation
- Plugin directory: Distributable WordPress plugin

Build the plugin with `./build.sh` or `make build`.