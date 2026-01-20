# Quick Start Guide - AI Image Marker

Get started with AI Image Marker in 5 minutes!

## Installation (30 seconds)

1. Copy the `ai-image-marker` folder to `/wp-content/plugins/`
2. Go to WordPress Admin → Plugins
3. Click "Activate" on "AI Image Marker"

Done! ✓

## Mark Your First Image (1 minute)

### Option A: Grid View
1. Go to **Media Library**
2. Click any image
3. Check **"AI Generated"** checkbox
4. The image now shows AI notices on your site!

### Option B: List View
1. Go to **Media Library** → Switch to List view
2. Hover over an image → Click **Quick Edit**
3. Check **"AI Generated"**
4. Click **Update**

## See It In Action (30 seconds)

1. Create a new post
2. Insert the AI-marked image
3. Add a caption to the image
4. Publish and view the post
5. You'll see: **"• Generated with artificial intelligence"** below the caption

## Language Settings (15 seconds)

### For Norwegian:
1. Go to **Settings → General**
2. Set "Site Language" to **"Norsk bokmål"**
3. Save

The plugin now displays in Norwegian!

## What Happens Automatically

✓ AI notices appear on all images with captions  
✓ Images get `ai-generated-image` CSS class  
✓ Media library shows AI status in a column  
✓ All text respects your WordPress language setting  

## Quick Tips

**Bulk Update**: Use List view + Quick Edit to mark multiple images quickly

**Check Status**: Look for the green checkmark (✓) in the "AI Generated" column

**Featured Images**: Use helper function `is_ai_generated_image($id)` in your theme

**Custom Styling**: Add CSS for `.ai-generated-notice` in your theme

## Next Steps

- Read `README.md` for full documentation
- Check `EXAMPLES.md` for theme integration examples
- See `INSTALL.md` for troubleshooting

## Support

Having issues? Check that:
- Plugin is activated
- WordPress is version 5.0+
- Images have captions (notices appear with captions)
- Browser cache is cleared

---

**That's it!** You're ready to transparently mark AI-generated content on your WordPress site.