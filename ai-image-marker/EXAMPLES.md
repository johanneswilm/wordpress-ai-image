# AI Image Marker - Usage Examples

This document provides practical examples for theme developers and WordPress users who want to customize or extend the AI Image Marker plugin.

## Basic Usage Examples

### Example 1: Checking if an Image is AI-Generated

```php
<?php
// Get the featured image ID
$thumbnail_id = get_post_thumbnail_id();

// Check if it's AI-generated
if (is_ai_generated_image($thumbnail_id)) {
    echo '<div class="ai-notice">This post features an AI-generated image</div>';
}
?>
```

### Example 2: Display AI Notice on Featured Images

Add this to your theme's `functions.php`:

```php
<?php
add_filter('post_thumbnail_html', 'add_ai_notice_to_thumbnail', 10, 5);

function add_ai_notice_to_thumbnail($html, $post_id, $post_thumbnail_id, $size, $attr) {
    if (is_ai_generated_image($post_thumbnail_id)) {
        $notice = get_ai_image_notice($post_thumbnail_id);
        $html .= '<div class="thumbnail-ai-notice">' . $notice . '</div>';
    }
    return $html;
}
?>
```

### Example 3: Add AI Badge to Gallery Images

```php
<?php
add_filter('wp_get_attachment_image', 'add_ai_badge_to_gallery', 10, 5);

function add_ai_badge_to_gallery($html, $attachment_id, $size, $icon, $attr) {
    if (is_ai_generated_image($attachment_id)) {
        // Add a visual badge
        $badge = '<span class="ai-badge" title="AI Generated">AI</span>';
        $html = '<div class="image-with-badge">' . $html . $badge . '</div>';
    }
    return $html;
}
?>
```

## Advanced Theme Integration

### Example 4: Custom Template for AI Images

Create a custom display for AI-generated images in your theme:

```php
<?php
function display_post_image($post_id) {
    $thumbnail_id = get_post_thumbnail_id($post_id);
    
    if (!$thumbnail_id) {
        return;
    }
    
    $image_html = get_the_post_thumbnail($post_id, 'large');
    $caption = wp_get_attachment_caption($thumbnail_id);
    $is_ai = is_ai_generated_image($thumbnail_id);
    
    ?>
    <figure class="post-featured-image <?php echo $is_ai ? 'ai-generated' : ''; ?>">
        <?php echo $image_html; ?>
        <?php if ($caption || $is_ai) : ?>
            <figcaption>
                <?php if ($caption) : ?>
                    <span class="image-caption"><?php echo esc_html($caption); ?></span>
                <?php endif; ?>
                <?php if ($is_ai) : ?>
                    <?php echo get_ai_image_notice($thumbnail_id); ?>
                <?php endif; ?>
            </figcaption>
        <?php endif; ?>
    </figure>
    <?php
}
?>
```

### Example 5: WooCommerce Product Images

Add AI notices to WooCommerce product images:

```php
<?php
add_action('woocommerce_before_single_product_summary', 'show_ai_notice_for_product_image', 25);

function show_ai_notice_for_product_image() {
    global $product;
    $image_id = $product->get_image_id();
    
    if (is_ai_generated_image($image_id)) {
        echo '<div class="woocommerce-ai-notice">';
        echo get_ai_image_notice($image_id);
        echo '</div>';
    }
}
?>
```

### Example 6: REST API Integration

Expose AI-generated status in WordPress REST API:

```php
<?php
add_action('rest_api_init', 'register_ai_generated_field');

function register_ai_generated_field() {
    register_rest_field('attachment', 'ai_generated', array(
        'get_callback' => function($object) {
            return is_ai_generated_image($object['id']);
        },
        'update_callback' => function($value, $object) {
            if ($value) {
                update_post_meta($object->ID, '_ai_generated_image', '1');
            } else {
                delete_post_meta($object->ID, '_ai_generated_image');
            }
        },
        'schema' => array(
            'description' => 'Whether the image was generated with AI',
            'type' => 'boolean',
        ),
    ));
}
?>
```

## Custom Styling Examples

### Example 7: CSS Styling for AI Notices

Add to your theme's `style.css`:

```css
/* Basic AI notice styling */
.ai-generated-notice {
    display: inline-block;
    font-size: 0.85em;
    color: #666;
    font-style: italic;
    margin-top: 5px;
}

/* Badge style */
.ai-generated-notice::before {
    content: '🤖 ';
    margin-right: 3px;
}

/* Highlight AI images */
.ai-generated-image {
    border: 2px solid #e3f2fd;
    padding: 2px;
}

/* Alternative badge design */
.ai-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 11px;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

/* Responsive design */
@media (max-width: 768px) {
    .ai-generated-notice {
        font-size: 0.8em;
    }
}
```

### Example 8: Animated AI Badge

```css
@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.6; }
}

.ai-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background: #6366f1;
    color: white;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 10px;
    font-weight: 600;
    animation: pulse 2s infinite;
    box-shadow: 0 2px 8px rgba(99, 102, 241, 0.4);
}
```

## JavaScript Examples

### Example 9: Add Interactive Tooltips

Add to your theme's JavaScript:

```javascript
jQuery(document).ready(function($) {
    $('.ai-generated-image').each(function() {
        var $img = $(this);
        var $tooltip = $('<div class="ai-tooltip">Generated with AI</div>');
        
        $img.parent().css('position', 'relative');
        $img.after($tooltip);
        
        $img.hover(
            function() { $tooltip.fadeIn(200); },
            function() { $tooltip.fadeOut(200); }
        );
    });
});
```

### Example 10: Filter Gallery by AI Status

```javascript
jQuery(document).ready(function($) {
    // Add filter buttons
    $('.gallery').before(
        '<div class="gallery-filters">' +
        '<button data-filter="all">All Images</button>' +
        '<button data-filter="ai">AI Generated</button>' +
        '<button data-filter="non-ai">Non-AI</button>' +
        '</div>'
    );
    
    // Filter functionality
    $('.gallery-filters button').on('click', function() {
        var filter = $(this).data('filter');
        
        $('.gallery-filters button').removeClass('active');
        $(this).addClass('active');
        
        $('.gallery img').each(function() {
            var $img = $(this);
            var isAI = $img.hasClass('ai-generated-image');
            
            if (filter === 'all') {
                $img.closest('.gallery-item').show();
            } else if (filter === 'ai') {
                $img.closest('.gallery-item').toggle(isAI);
            } else if (filter === 'non-ai') {
                $img.closest('.gallery-item').toggle(!isAI);
            }
        });
    });
});
```

## Shortcode Examples

### Example 11: Custom Shortcode for AI Images

Add to your theme's `functions.php`:

```php
<?php
add_shortcode('ai_image', 'display_ai_image_shortcode');

function display_ai_image_shortcode($atts) {
    $atts = shortcode_atts(array(
        'id' => 0,
        'size' => 'medium',
        'show_notice' => 'yes',
    ), $atts);
    
    $image_id = intval($atts['id']);
    if (!$image_id) {
        return '';
    }
    
    $output = '<div class="ai-image-shortcode">';
    $output .= wp_get_attachment_image($image_id, $atts['size']);
    
    if ($atts['show_notice'] === 'yes' && is_ai_generated_image($image_id)) {
        $output .= get_ai_image_notice($image_id);
    }
    
    $output .= '</div>';
    
    return $output;
}
?>
```

Usage: `[ai_image id="123" size="large" show_notice="yes"]`

### Example 12: Gallery of Only AI Images

```php
<?php
add_shortcode('ai_gallery', 'display_ai_gallery_shortcode');

function display_ai_gallery_shortcode($atts) {
    $atts = shortcode_atts(array(
        'columns' => 3,
        'size' => 'medium',
    ), $atts);
    
    $args = array(
        'post_type' => 'attachment',
        'post_status' => 'inherit',
        'posts_per_page' => -1,
        'meta_query' => array(
            array(
                'key' => '_ai_generated_image',
                'value' => '1',
                'compare' => '='
            )
        )
    );
    
    $ai_images = get_posts($args);
    
    if (empty($ai_images)) {
        return '<p>No AI-generated images found.</p>';
    }
    
    $output = '<div class="ai-gallery columns-' . esc_attr($atts['columns']) . '">';
    
    foreach ($ai_images as $image) {
        $output .= '<div class="ai-gallery-item">';
        $output .= wp_get_attachment_image($image->ID, $atts['size']);
        $output .= '<div class="ai-gallery-caption">';
        $output .= wp_get_attachment_caption($image->ID);
        $output .= '</div>';
        $output .= '</div>';
    }
    
    $output .= '</div>';
    
    return $output;
}
?>
```

Usage: `[ai_gallery columns="4" size="thumbnail"]`

## Query Examples

### Example 13: Get All AI-Generated Images

```php
<?php
function get_ai_generated_images($args = array()) {
    $defaults = array(
        'post_type' => 'attachment',
        'post_status' => 'inherit',
        'posts_per_page' => -1,
        'meta_query' => array(
            array(
                'key' => '_ai_generated_image',
                'value' => '1',
                'compare' => '='
            )
        )
    );
    
    $args = wp_parse_args($args, $defaults);
    
    return get_posts($args);
}

// Usage
$ai_images = get_ai_generated_images();
foreach ($ai_images as $image) {
    echo wp_get_attachment_image($image->ID, 'thumbnail');
}
?>
```

### Example 14: Count AI Images

```php
<?php
function count_ai_generated_images() {
    global $wpdb;
    
    $count = $wpdb->get_var(
        "SELECT COUNT(*) FROM {$wpdb->postmeta} 
        WHERE meta_key = '_ai_generated_image' 
        AND meta_value = '1'"
    );
    
    return intval($count);
}

// Display statistics
echo 'Total AI-generated images: ' . count_ai_generated_images();
?>
```

## Widget Example

### Example 15: AI Images Widget

```php
<?php
class AI_Images_Widget extends WP_Widget {
    
    public function __construct() {
        parent::__construct(
            'ai_images_widget',
            'AI Generated Images',
            array('description' => 'Display recent AI-generated images')
        );
    }
    
    public function widget($args, $instance) {
        echo $args['before_widget'];
        
        if (!empty($instance['title'])) {
            echo $args['before_title'] . apply_filters('widget_title', $instance['title']) . $args['after_title'];
        }
        
        $ai_images = get_ai_generated_images(array(
            'posts_per_page' => $instance['number'] ?? 5,
            'orderby' => 'date',
            'order' => 'DESC'
        ));
        
        if ($ai_images) {
            echo '<div class="ai-images-widget">';
            foreach ($ai_images as $image) {
                echo '<div class="ai-widget-item">';
                echo wp_get_attachment_image($image->ID, 'thumbnail');
                echo '</div>';
            }
            echo '</div>';
        }
        
        echo $args['after_widget'];
    }
    
    public function form($instance) {
        $title = !empty($instance['title']) ? $instance['title'] : 'AI Images';
        $number = !empty($instance['number']) ? $instance['number'] : 5;
        ?>
        <p>
            <label for="<?php echo $this->get_field_id('title'); ?>">Title:</label>
            <input class="widefat" id="<?php echo $this->get_field_id('title'); ?>" 
                   name="<?php echo $this->get_field_name('title'); ?>" type="text" 
                   value="<?php echo esc_attr($title); ?>">
        </p>
        <p>
            <label for="<?php echo $this->get_field_id('number'); ?>">Number of images:</label>
            <input class="tiny-text" id="<?php echo $this->get_field_id('number'); ?>" 
                   name="<?php echo $this->get_field_name('number'); ?>" type="number" 
                   step="1" min="1" value="<?php echo esc_attr($number); ?>" size="3">
        </p>
        <?php
    }
    
    public function update($new_instance, $old_instance) {
        $instance = array();
        $instance['title'] = (!empty($new_instance['title'])) ? sanitize_text_field($new_instance['title']) : '';
        $instance['number'] = (!empty($new_instance['number'])) ? absint($new_instance['number']) : 5;
        return $instance;
    }
}

add_action('widgets_init', function() {
    register_widget('AI_Images_Widget');
});
?>
```

## Block Editor (Gutenberg) Example

### Example 16: Add AI Notice to Image Block

```php
<?php
add_filter('render_block', 'add_ai_notice_to_image_block', 10, 2);

function add_ai_notice_to_image_block($block_content, $block) {
    if ($block['blockName'] !== 'core/image') {
        return $block_content;
    }
    
    $attachment_id = isset($block['attrs']['id']) ? $block['attrs']['id'] : 0;
    
    if ($attachment_id && is_ai_generated_image($attachment_id)) {
        $notice = get_ai_image_notice($attachment_id);
        $block_content = str_replace(
            '</figure>',
            '<div class="ai-block-notice">' . $notice . '</div></figure>',
            $block_content
        );
    }
    
    return $block_content;
}
?>
```

## Performance Optimization

### Example 17: Cache AI Status

```php
<?php
function get_cached_ai_status($attachment_id) {
    $cache_key = 'ai_status_' . $attachment_id;
    $cached = wp_cache_get($cache_key, 'ai_image_marker');
    
    if ($cached === false) {
        $cached = is_ai_generated_image($attachment_id);
        wp_cache_set($cache_key, $cached, 'ai_image_marker', 3600); // Cache for 1 hour
    }
    
    return $cached;
}
?>
```

These examples should give you a comprehensive starting point for integrating and customizing the AI Image Marker plugin in your WordPress theme or site!