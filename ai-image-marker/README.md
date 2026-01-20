# AI Image Marker

A WordPress plugin that allows you to mark images in the media library as AI-generated and automatically displays this information to website visitors.

## Description

AI Image Marker enables WordPress administrators to identify images created with artificial intelligence tools. When marked, these images will display a notice ("Generated with artificial intelligence") on the frontend, promoting transparency about AI-generated content.

## Features

- **Easy Marking**: Add a simple checkbox to the media library to mark images as AI-generated
- **Automatic Display**: AI-generated notices are automatically added to image captions on the frontend
- **Media Library Column**: See at a glance which images are marked as AI-generated in the media library list view
- **Quick Edit Support**: Mark or unmark images directly from the media library list view
- **Internationalized**: Full support for multiple languages
- **Norwegian Bokmål**: Includes complete Norwegian translation
- **Developer-Friendly**: Provides helper functions for theme developers

## Installation

1. Download the `ai-image-marker` folder
2. Upload it to your WordPress installation's `/wp-content/plugins/` directory
3. Activate the plugin through the 'Plugins' menu in WordPress
4. Start marking your AI-generated images in the Media Library

## Usage

### Marking Images as AI-Generated

#### Method 1: Media Library (Grid View)
1. Go to Media Library in WordPress admin
2. Click on an image to open the details panel
3. Check the "AI Generated" checkbox
4. The image will now display the AI notice on the frontend

#### Method 2: Media Library (List View)
1. Go to Media Library and switch to List view
2. Use Quick Edit on any image
3. Check the "AI Generated" checkbox
4. Click "Update"

#### Method 3: While Editing Posts
1. Insert an image into a post/page
2. Click on the image in the media selector
3. Check the "AI Generated" checkbox in the attachment details

### Frontend Display

Once an image is marked as AI-generated:
- Images with captions will show: "• Generated with artificial intelligence" after the caption text
- The notice is styled to be visible but unobtrusive
- Images receive a CSS class `ai-generated-image` for custom styling

## Language Support

The plugin is fully internationalized and includes translations for:
- **English** (default)
- **Norwegian Bokmål** (nb_NO)

### Adding Additional Languages

To add support for additional languages:

1. Copy `languages/ai-image-marker.pot` to create a new PO file
2. Name it `ai-image-marker-{locale}.po` (e.g., `ai-image-marker-sv_SE.po` for Swedish)
3. Translate the strings using a PO editor like [Poedit](https://poedit.net/)
4. Generate the MO file
5. Place both PO and MO files in the `languages` directory

## Developer Reference

### Helper Functions

The plugin provides two helper functions for theme developers:

#### `is_ai_generated_image($attachment_id)`

Check if an image is marked as AI-generated.

```php
<?php
$attachment_id = get_post_thumbnail_id();
if (is_ai_generated_image($attachment_id)) {
    echo '<p>This is an AI-generated image.</p>';
}
?>
```

#### `get_ai_image_notice($attachment_id)`

Get the HTML notice for an AI-generated image.

```php
<?php
$attachment_id = get_post_thumbnail_id();
echo get_ai_image_notice($attachment_id);
?>
```

### Filters

#### `wp_get_attachment_image_attributes`

The plugin adds the following attributes to AI-generated images:
- `data-ai-generated="true"`
- CSS class: `ai-generated-image`

### Custom Styling

You can customize the appearance of AI notices by adding CSS to your theme:

```css
.ai-generated-notice {
    color: #your-color;
    font-size: 0.85em;
    background: #your-background;
    padding: 2px 8px;
    border-radius: 3px;
}
```

## Technical Details

- **Meta Key**: `_ai_generated_image` (stored as post meta on attachment posts)
- **Text Domain**: `ai-image-marker`
- **Minimum WordPress Version**: 5.0
- **PHP Version**: 7.0 or higher recommended

## Privacy & Compliance

This plugin helps website owners comply with transparency requirements regarding AI-generated content. It does not collect or transmit any data externally.

## Changelog

### 1.0.0
- Initial release
- Media library checkbox for marking AI images
- Frontend display of AI notices
- Norwegian Bokmål translation
- Quick edit support
- Media library column
- Helper functions for developers

## Support

For bug reports, feature requests, or questions, please create an issue in the plugin repository.

## License

This plugin is licensed under the GPL v2 or later.
