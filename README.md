# WordPress AI Image Marker Plugin

A complete WordPress plugin that enables transparency in AI-generated content by allowing administrators to mark images as AI-generated and automatically displaying notices to website visitors.

## 🎯 Overview

This plugin addresses the growing need for transparency around AI-generated content on websites. It provides a simple checkbox interface in WordPress Media Library to mark images as AI-generated, and automatically displays appropriate notices to visitors viewing those images on the frontend.

## ✨ Key Features

- **Simple Marking System**: Easy checkbox in Media Library to mark AI-generated images
- **Automatic Display**: AI notices automatically appear with image captions on the frontend
- **Media Library Integration**: Column view showing AI status at a glance
- **Quick Edit Support**: Bulk operations support for efficient management
- **Fully Internationalized**: Built-in support for English and Norwegian Bokmål
- **Developer Friendly**: Helper functions and hooks for theme customization
- **Zero Dependencies**: Pure WordPress - no external libraries required
- **Privacy Focused**: No external API calls or data collection

## 📦 What's Included

```
ai-image-marker/               # WordPress plugin (install this folder)
├── ai-image-marker.php        # Main plugin file
├── admin.js                   # Admin interface JavaScript
├── languages/                 # Translation files
│   ├── ai-image-marker.pot    # Translation template
│   ├── ai-image-marker-nb_NO.po  # Norwegian translation (source)
│   └── ai-image-marker-nb_NO.mo  # Norwegian translation (compiled)
├── README.md                  # User documentation
├── INSTALL.md                 # Installation guide
├── QUICKSTART.md              # 5-minute quick start
├── EXAMPLES.md                # Developer examples
└── LICENSE                    # GPL v2 License

PROJECT_OVERVIEW.md            # Technical overview (this directory)
```

## 🚀 Quick Start

### Installation (3 steps)

1. **Copy the plugin folder**
   ```bash
   cp -r ai-image-marker /path/to/wordpress/wp-content/plugins/
   ```

2. **Activate the plugin**
   - Go to WordPress Admin → Plugins
   - Find "AI Image Marker"
   - Click "Activate"

3. **Start using**
   - Go to Media Library
   - Click any image
   - Check "AI Generated"
   - Done! ✓

### First Use (1 minute)

1. Upload or select an image in Media Library
2. Check the **"AI Generated"** checkbox
3. Insert the image into a post with a caption
4. View the post - you'll see: *"• Generated with artificial intelligence"*

## 🌍 Language Support

### Currently Supported

- **English** (default) - Built-in
- **Norwegian Bokmål** (nb_NO) - Full translation included

### Enable Norwegian

1. Go to **Settings → General**
2. Set "Site Language" to **"Norsk bokmål"**
3. Save changes

All plugin text automatically switches to Norwegian!

### Add More Languages

1. Use `languages/ai-image-marker.pot` as template
2. Create `ai-image-marker-{locale}.po` file
3. Translate strings
4. Compile to `.mo` file using `msgfmt`
5. Place both files in `languages/` directory

## 💡 Usage Examples

### For Content Managers

**Mark an image in Grid View:**
```
Media Library → Click image → Check "AI Generated" → Done
```

**Mark an image in List View:**
```
Media Library → Quick Edit → Check "AI Generated" → Update
```

**Bulk operations:**
```
List View → Select multiple images → Use Quick Edit
```

### For Theme Developers

**Check if image is AI-generated:**
```php
<?php
$thumbnail_id = get_post_thumbnail_id();
if (is_ai_generated_image($thumbnail_id)) {
    echo '<p>This is an AI-generated image</p>';
}
?>
```

**Display AI notice:**
```php
<?php
$attachment_id = get_post_thumbnail_id();
echo get_ai_image_notice($attachment_id);
?>
```

**Custom featured image display:**
```php
<?php
add_filter('post_thumbnail_html', 'add_ai_notice_to_thumbnail', 10, 5);

function add_ai_notice_to_thumbnail($html, $post_id, $thumbnail_id, $size, $attr) {
    if (is_ai_generated_image($thumbnail_id)) {
        $notice = get_ai_image_notice($thumbnail_id);
        $html .= '<div class="ai-notice">' . $notice . '</div>';
    }
    return $html;
}
?>
```

See `ai-image-marker/EXAMPLES.md` for 15+ more examples!

## 🎨 Customization

### CSS Styling

The plugin adds minimal inline CSS. Customize the appearance:

```css
/* Style the AI notice text */
.ai-generated-notice {
    color: #0073aa;
    font-size: 0.9em;
    font-style: italic;
    background: #f0f6fc;
    padding: 3px 8px;
    border-radius: 3px;
}

/* Style AI-marked images */
.ai-generated-image {
    border: 2px solid #e3f2fd;
}

/* Style captions containing AI notices */
.ai-generated-caption {
    background: #f5f5f5;
}
```

### JavaScript Integration

AI-generated images have a data attribute:

```javascript
// Find all AI images
document.querySelectorAll('[data-ai-generated="true"]').forEach(img => {
    // Add custom functionality
    img.classList.add('your-custom-class');
});
```

## 📋 Requirements

- **WordPress**: 5.0 or higher
- **PHP**: 7.0 or higher (7.4+ recommended)
- **MySQL**: 5.6+ or MariaDB 10.0+
- **Permissions**: Standard WordPress file permissions

## 🔧 Technical Details

### Database Storage
- **Meta Key**: `_ai_generated_image`
- **Storage Location**: `wp_postmeta` table
- **Value**: `1` for AI-generated, deleted for regular images

### WordPress Hooks
- `attachment_fields_to_edit` - Media library checkbox
- `manage_media_columns` - Media library column
- `img_caption_shortcode` - Caption modification
- `wp_get_attachment_image_attributes` - CSS classes

### Helper Functions
- `is_ai_generated_image($attachment_id)` - Boolean check
- `get_ai_image_notice($attachment_id)` - HTML notice output

## 📖 Documentation

| File | Description | Audience |
|------|-------------|----------|
| `ai-image-marker/README.md` | Complete documentation | All users |
| `ai-image-marker/QUICKSTART.md` | 5-minute guide | New users |
| `ai-image-marker/INSTALL.md` | Installation & troubleshooting | Admins |
| `ai-image-marker/EXAMPLES.md` | Code examples | Developers |
| `PROJECT_OVERVIEW.md` | Technical overview | Developers |

## 🐛 Troubleshooting

### Notice not appearing?
- Ensure image has a caption
- Clear browser and WordPress cache
- Check theme supports caption shortcodes

### Translation not working?
- Verify WordPress language setting
- Check `.mo` file exists in `languages/`
- Clear all caches

### Checkbox not visible?
- Hard refresh browser (Ctrl+F5)
- Check for plugin conflicts
- Verify plugin is activated

See `ai-image-marker/INSTALL.md` for detailed troubleshooting.

## 🔒 Privacy & Security

- ✅ No external API calls
- ✅ No data transmitted externally
- ✅ All inputs sanitized and escaped
- ✅ Follows WordPress security standards
- ✅ GPL v2 licensed
- ✅ No tracking or analytics

## 🤝 Compatibility

### Tested With
- WordPress 5.0 - 6.4+
- Classic Editor
- Block Editor (Gutenberg)
- WooCommerce
- Popular page builders
- Common caching plugins

### Theme Compatibility
Works with any WordPress theme that follows standard WordPress conventions.

## 📊 What Gets Marked

Common AI image tools that might generate images:
- DALL-E
- Midjourney
- Stable Diffusion
- Adobe Firefly
- Canva AI
- And any other AI image generators

## 🎓 Learning Resources

1. **Start Here**: Read `QUICKSTART.md` for immediate use
2. **Installation Help**: See `INSTALL.md` for setup
3. **Developers**: Check `EXAMPLES.md` for code samples
4. **Technical**: Review `PROJECT_OVERVIEW.md` for architecture

## 📝 Version Information

- **Current Version**: 1.0.0
- **Release Date**: January 2025
- **Status**: Production Ready
- **License**: GPL v2 or later

## 🌟 Benefits

### For Website Owners
- Comply with transparency guidelines
- Build trust with visitors
- Easy content management
- No technical knowledge required

### For Developers
- Clean, documented code
- Helper functions provided
- WordPress standards compliance
- Easy to extend and customize

### For Visitors
- Clear disclosure of AI content
- Improved transparency
- Better understanding of content sources

## 🚀 Future Enhancements

Potential features for future versions:
- Bulk actions in media library
- Settings page for custom notice text
- Optional watermarking
- Page builder integrations
- Usage analytics
- Export/import functionality

## 📞 Support

Having issues? Follow this process:

1. **Check documentation** - Read the relevant guide
2. **Enable debug mode** - Check WordPress debug.log
3. **Test isolation** - Try with default theme and no other plugins
4. **Check requirements** - Verify WordPress/PHP versions

## 🎉 Getting Started

Ready to add transparency to your AI-generated content?

```bash
# Quick install
cd /path/to/wordpress/wp-content/plugins/
cp -r /path/to/this/repo/ai-image-marker .
# Then activate via WordPress admin!
```

## 📄 License

This plugin is licensed under the **GNU General Public License v2 (or later)**, making it free to use, modify, and distribute.

See the `LICENSE` file for full license text.

---

**Ready to get started?** Open `ai-image-marker/QUICKSTART.md` for a 5-minute guide!

**Need help?** Check `ai-image-marker/INSTALL.md` for detailed instructions.

**Developer?** See `ai-image-marker/EXAMPLES.md` for code samples.

---

**Project Status**: ✅ Production Ready  
**Maintenance**: 🟢 Active  
**Created**: January 2025