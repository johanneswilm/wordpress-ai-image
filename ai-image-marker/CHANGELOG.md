# Changelog

All notable changes to the AI Image Marker plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-20

### Added
- Initial release of AI Image Marker plugin
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

### Planned Features
- Bulk actions support in media library
- Settings page for customizing notice text
- Optional AI image watermarking
- REST API endpoint extensions
- Block editor (Gutenberg) sidebar integration
- WooCommerce integration enhancements
- Usage statistics and analytics
- Export/import AI image lists
- Custom post type support beyond attachments

---

## Version History

- **1.0.0** - Initial public release (January 2025)

---

## Upgrade Notice

### 1.0.0
First release of AI Image Marker. Provides simple marking and display of AI-generated images in WordPress media library.

---

**Note**: This plugin stores AI-generated status in WordPress database as post metadata. Uninstalling the plugin will not automatically remove this data, allowing you to preserve your markings if you reinstall later.