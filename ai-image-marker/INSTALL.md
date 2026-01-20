# Installation Guide - AI Image Marker

## Quick Installation

1. **Upload the plugin**
   - Copy the entire `ai-image-marker` folder to `/wp-content/plugins/` on your WordPress server
   - Or zip the folder and upload via WordPress admin: Plugins → Add New → Upload Plugin

2. **Activate the plugin**
   - Go to WordPress admin → Plugins
   - Find "AI Image Marker" in the list
   - Click "Activate"

3. **Start using**
   - Go to Media Library
   - Click on any image
   - Check the "AI Generated" checkbox
   - The notice will automatically appear on the frontend

## Detailed Installation Steps

### Method 1: FTP/SFTP Upload

1. Download or copy the `ai-image-marker` folder
2. Connect to your WordPress site via FTP/SFTP
3. Navigate to `/wp-content/plugins/`
4. Upload the entire `ai-image-marker` folder
5. Ensure the folder structure looks like this:
   ```
   /wp-content/plugins/ai-image-marker/
   ├── ai-image-marker.php
   ├── admin.js
   ├── README.md
   ├── INSTALL.md
   └── languages/
       ├── ai-image-marker.pot
       ├── ai-image-marker-nb_NO.po
       └── ai-image-marker-nb_NO.mo
   ```
6. Log into WordPress admin
7. Go to Plugins → Installed Plugins
8. Find "AI Image Marker" and click "Activate"

### Method 2: ZIP Upload via WordPress Admin

1. Create a ZIP file of the `ai-image-marker` folder
   ```bash
   cd /path/to/wordpress-ai-image
   zip -r ai-image-marker.zip ai-image-marker/
   ```
2. Log into WordPress admin
3. Go to Plugins → Add New → Upload Plugin
4. Click "Choose File" and select `ai-image-marker.zip`
5. Click "Install Now"
6. Click "Activate Plugin"

### Method 3: Direct Server Access

If you have shell access to your server:

```bash
cd /var/www/html/wp-content/plugins/
cp -r /path/to/wordpress-ai-image/ai-image-marker .
chown -R www-data:www-data ai-image-marker/
chmod -R 755 ai-image-marker/
```

Then activate via WordPress admin.

## Language Configuration

### Enabling Norwegian Bokmål

The plugin will automatically use Norwegian if your WordPress installation is set to Norwegian:

1. Go to Settings → General
2. Set "Site Language" to "Norsk bokmål"
3. Save changes

The plugin will now display all text in Norwegian.

### Verifying Translation Files

Ensure these files exist and have correct permissions:

```bash
ls -la wp-content/plugins/ai-image-marker/languages/
```

You should see:
- `ai-image-marker-nb_NO.mo` (compiled translation - required)
- `ai-image-marker-nb_NO.po` (source translation - optional)
- `ai-image-marker.pot` (translation template - optional)

If the `.mo` file is missing, compile it:

```bash
cd wp-content/plugins/ai-image-marker/languages/
msgfmt ai-image-marker-nb_NO.po -o ai-image-marker-nb_NO.mo
```

## Post-Installation Configuration

### No Configuration Required!

The plugin works out of the box. However, you may want to:

1. **Test the functionality**
   - Upload a test image to Media Library
   - Mark it as "AI Generated"
   - Insert it into a test post with a caption
   - View the post to see the AI notice

2. **Customize styling (optional)**
   - Add custom CSS to your theme's `style.css` or via Customizer
   - Example:
     ```css
     .ai-generated-notice {
         color: #0073aa;
         font-weight: bold;
         background: #f0f6fc;
         padding: 3px 8px;
         border-radius: 3px;
     }
     ```

3. **Update existing images**
   - Go through your Media Library
   - Mark any AI-generated images you've previously uploaded
   - The notices will appear automatically

## Troubleshooting

### Plugin not showing in admin

**Problem**: Can't see "AI Image Marker" in the plugins list

**Solutions**:
- Verify the folder is named exactly `ai-image-marker` (lowercase, with hyphen)
- Check that `ai-image-marker.php` is directly inside the folder (not nested)
- Check file permissions: folders should be 755, files should be 644
- Try deactivating and reactivating all plugins

### Checkbox not appearing in Media Library

**Problem**: Don't see the "AI Generated" checkbox

**Solutions**:
- Hard refresh your browser (Ctrl+F5 or Cmd+Shift+R)
- Clear WordPress cache if using a caching plugin
- Check browser console for JavaScript errors
- Try a different browser
- Deactivate other plugins to check for conflicts

### Translation not working

**Problem**: Still seeing English text when Norwegian is selected

**Solutions**:
- Verify WordPress language is set to "Norsk bokmål" in Settings → General
- Check that `ai-image-marker-nb_NO.mo` exists in the `languages` folder
- Clear all caches (browser, WordPress, server)
- Try regenerating the MO file:
  ```bash
  cd wp-content/plugins/ai-image-marker/languages/
  msgfmt -v ai-image-marker-nb_NO.po -o ai-image-marker-nb_NO.mo
  ```
- Check WordPress language code matches exactly: `nb_NO`

### Notice not appearing on frontend

**Problem**: Marked images don't show AI notice

**Solutions**:
- Ensure the image has a caption (the notice appears with captions)
- Check if your theme supports WordPress caption shortcodes
- Clear your browser cache and any caching plugins
- Check that the image is being inserted with the caption
- Use the helper function `get_ai_image_notice()` in your theme if needed

### Permission errors

**Problem**: Can't write files or activate plugin

**Solutions**:
```bash
# Fix ownership (adjust www-data to your web server user)
chown -R www-data:www-data /path/to/wp-content/plugins/ai-image-marker/

# Fix permissions
find /path/to/wp-content/plugins/ai-image-marker/ -type d -exec chmod 755 {} \;
find /path/to/wp-content/plugins/ai-image-marker/ -type f -exec chmod 644 {} \;
```

## Requirements

- **WordPress**: 5.0 or higher
- **PHP**: 7.0 or higher (7.4+ recommended)
- **MySQL**: 5.6 or higher / MariaDB 10.0 or higher

## Updating the Plugin

When a new version is released:

1. Deactivate the plugin (your data will be preserved)
2. Delete the old `ai-image-marker` folder
3. Upload the new version
4. Activate the plugin

**Note**: The AI-generated flags on your images are stored in the WordPress database and will not be lost during updates.

## Uninstallation

To completely remove the plugin:

1. Deactivate the plugin via WordPress admin
2. Delete the plugin via Plugins → Installed Plugins → Delete
3. Or manually delete the `ai-image-marker` folder from `/wp-content/plugins/`

**Note**: If you want to preserve the AI-generated flags on your images for future use, the data remains in your database even after uninstalling. The data is stored as post metadata and won't interfere with WordPress if the plugin is removed.

To manually remove all AI-generated flags from the database (if desired):

```sql
DELETE FROM wp_postmeta WHERE meta_key = '_ai_generated_image';
```

(Replace `wp_` with your database prefix if different)

## Support

For issues not covered here, please:
1. Check the README.md file for additional documentation
2. Enable WordPress debug mode to see detailed error messages
3. Check your server's PHP error log
4. Create an issue in the plugin repository with details about your WordPress version, PHP version, and the specific problem

## Getting Help

Include this information when asking for support:
- WordPress version
- PHP version
- Active theme name
- List of active plugins
- Error messages (if any)
- Steps to reproduce the issue