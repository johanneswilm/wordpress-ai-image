<?php
/**
 * Plugin Name: AI Image Marker
 * Plugin URI: https://github.com/johanneswilm/ai-image-marker
 * Description: Mark images in the media library as AI-generated and display this information on the frontend
 * Version: 1.0.1
 * Author: Johannes Wilm
 * Author URI: https://www.johanneswilm.org
 * Text Domain: ai-image-marker
 * Domain Path: /languages
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

class AI_Image_Marker {

    /**
     * Meta key for storing AI-generated flag
     */
    const META_KEY = '_ai_generated_image';

    /**
     * Plugin version
     */
    const VERSION = '1.0.1';

    /**
     * Instance of this class
     */
    private static $instance = null;

    /**
     * Get singleton instance
     */
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Constructor
     */
    private function __construct() {
        add_action('plugins_loaded', array($this, 'load_textdomain'));
        add_action('admin_init', array($this, 'admin_init'));
        add_filter('attachment_fields_to_edit', array($this, 'add_attachment_field'), 10, 2);
        add_filter('attachment_fields_to_save', array($this, 'save_attachment_field'), 10, 2);
        add_filter('wp_get_attachment_image_attributes', array($this, 'add_ai_image_attributes'), 10, 3);
        add_filter('img_caption_shortcode', array($this, 'modify_image_caption'), 10, 3);
        add_filter('render_block', array($this, 'modify_image_block'), 10, 2);
        add_filter('post_thumbnail_html', array($this, 'add_featured_image_notice'), 10, 5);
        add_action('wp_enqueue_scripts', array($this, 'enqueue_frontend_styles'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_scripts'));

        // Add custom column to media library list view
        add_filter('manage_media_columns', array($this, 'add_media_column'));
        add_action('manage_media_custom_column', array($this, 'display_media_column'), 10, 2);
    }

    /**
     * Load plugin textdomain for translations
     */
    public function load_textdomain() {
        load_plugin_textdomain(
            'ai-image-marker',
            false,
            dirname(plugin_basename(__FILE__)) . '/languages'
        );
    }

    /**
     * Initialize admin functionality
     */
    public function admin_init() {
        // Add quick edit support
        add_action('quick_edit_custom_box', array($this, 'add_quick_edit_field'), 10, 2);
        add_action('save_post', array($this, 'save_quick_edit_data'));
    }

    /**
     * Add custom field to attachment edit screen
     */
    public function add_attachment_field($form_fields, $post) {
        $checked = get_post_meta($post->ID, self::META_KEY, true);

        $form_fields['ai_generated'] = array(
            'label' => __('AI Generated', 'ai-image-marker'),
            'input' => 'html',
            'html' => sprintf(
                '<label for="attachments-%1$s-ai_generated">
                    <input type="checkbox" id="attachments-%1$s-ai_generated" name="attachments[%1$s][ai_generated]" value="1" %2$s />
                    %3$s
                </label>
                <p class="description">%4$s</p>',
                $post->ID,
                checked($checked, '1', false),
                __('This image was generated with artificial intelligence', 'ai-image-marker'),
                __('Check this box if the image was created using AI tools', 'ai-image-marker')
            ),
            'helps' => __('Mark images that were created with AI', 'ai-image-marker')
        );

        return $form_fields;
    }

    /**
     * Save attachment field data
     */
    public function save_attachment_field($post, $attachment) {
        if (isset($attachment['ai_generated'])) {
            update_post_meta($post['ID'], self::META_KEY, '1');
        } else {
            delete_post_meta($post['ID'], self::META_KEY);
        }

        return $post;
    }

    /**
     * Add custom column to media library
     */
    public function add_media_column($columns) {
        $columns['ai_generated'] = __('AI Generated', 'ai-image-marker');
        return $columns;
    }

    /**
     * Display custom column content
     */
    public function display_media_column($column_name, $post_id) {
        if ($column_name === 'ai_generated') {
            $is_ai = get_post_meta($post_id, self::META_KEY, true);
            if ($is_ai) {
                echo '<span class="dashicons dashicons-yes-alt" style="color: #46b450;" title="' . esc_attr__('AI Generated', 'ai-image-marker') . '"></span>';
            } else {
                echo '—';
            }
        }
    }

    /**
     * Add quick edit field
     */
    public function add_quick_edit_field($column_name, $post_type) {
        if ($column_name === 'ai_generated' && $post_type === 'attachment') {
            ?>
            <fieldset class="inline-edit-col-right">
                <div class="inline-edit-col">
                    <label class="alignleft">
                        <input type="checkbox" name="ai_generated" value="1" />
                        <span class="checkbox-title"><?php _e('AI Generated', 'ai-image-marker'); ?></span>
                    </label>
                </div>
            </fieldset>
            <?php
        }
    }

    /**
     * Save quick edit data
     */
    public function save_quick_edit_data($post_id) {
        if (defined('DOING_AUTOSAVE') && DOING_AUTOSAVE) {
            return;
        }

        if (get_post_type($post_id) !== 'attachment') {
            return;
        }

        if (!current_user_can('edit_post', $post_id)) {
            return;
        }

        if (isset($_POST['ai_generated'])) {
            update_post_meta($post_id, self::META_KEY, '1');
        } else {
            delete_post_meta($post_id, self::META_KEY);
        }
    }

    /**
     * Add data attributes to images for frontend display
     */
    public function add_ai_image_attributes($attr, $attachment, $size) {
        $is_ai = get_post_meta($attachment->ID, self::META_KEY, true);

        if ($is_ai) {
            $attr['data-ai-generated'] = 'true';

            // Add CSS class for easier styling
            if (isset($attr['class'])) {
                $attr['class'] .= ' ai-generated-image';
            } else {
                $attr['class'] = 'ai-generated-image';
            }
        }

        return $attr;
    }

    /**
     * Modify image caption to include AI notice
     */
    public function modify_image_caption($output, $attr, $content) {
        if (empty($attr['id'])) {
            return $output;
        }

        // Extract attachment ID from the id attribute (format: attachment_123)
        $attachment_id = 0;
        if (preg_match('/attachment_(\d+)/', $attr['id'], $matches)) {
            $attachment_id = (int) $matches[1];
        }

        if (!$attachment_id) {
            return $output;
        }

        $is_ai = get_post_meta($attachment_id, self::META_KEY, true);

        if (!$is_ai) {
            return $output;
        }

        // Get attributes
        $atts = shortcode_atts(array(
            'id'      => '',
            'align'   => 'alignnone',
            'width'   => '',
            'caption' => '',
            'class'   => '',
        ), $attr, 'caption');

        $atts['width'] = (int) $atts['width'];
        if ($atts['width'] < 1 || empty($atts['caption'])) {
            return $content;
        }

        $id = '';
        $class = trim('wp-caption ' . $atts['align'] . ' ' . $atts['class'] . ' ai-generated-caption');

        if ($atts['id']) {
            $atts['id'] = sanitize_html_class($atts['id']);
            $id = 'id="' . esc_attr($atts['id']) . '" ';
        }

        $ai_notice = '<span class="ai-generated-notice">' . esc_html__('Generated with artificial intelligence', 'ai-image-marker') . '</span>';

        $caption_width = 10 + $atts['width'];

        $output = sprintf(
            '<figure %s style="width: %dpx;" class="%s">%s<figcaption class="wp-caption-text">%s%s</figcaption></figure>',
            $id,
            $caption_width,
            esc_attr($class),
            do_shortcode($content),
            $ai_notice,
            $atts['caption']
        );

        return $output;
    }

    /**
     * Modify Block Editor (Gutenberg) image blocks to add AI notice
     */
    public function modify_image_block($block_content, $block) {
        // Only process image blocks
        if ($block['blockName'] !== 'core/image') {
            return $block_content;
        }

        // Get attachment ID from block attributes
        $attachment_id = isset($block['attrs']['id']) ? intval($block['attrs']['id']) : 0;

        if (!$attachment_id) {
            return $block_content;
        }

        // Check if image is AI-generated
        $is_ai = get_post_meta($attachment_id, self::META_KEY, true);

        if (!$is_ai) {
            return $block_content;
        }

        // Add AI-generated class to the figure element
        $block_content = str_replace(
            'class="wp-block-image',
            'class="wp-block-image ai-generated-caption',
            $block_content
        );

        // Add ai-generated-image class to img tag if not already present
        if (strpos($block_content, 'ai-generated-image') === false) {
            $block_content = preg_replace(
                '/(<img[^>]+class="[^"]*)(")/',
                '$1 ai-generated-image$2',
                $block_content
            );
        }

        // Create the AI notice
        $ai_notice = '<p class="ai-generated-notice">' . esc_html__('Generated with artificial intelligence', 'ai-image-marker') . '</p>';

        // Check if there's a figcaption
        if (strpos($block_content, '<figcaption') !== false) {
            // Insert notice inside the figcaption, BEFORE existing caption text
            $block_content = preg_replace(
                '/(<figcaption[^>]*>)(.*?)(<\/figcaption>)/s',
                '$1' . $ai_notice . '$2$3',
                $block_content
            );
        } else {
            // No caption exists, add figcaption with AI notice before closing figure tag
            $block_content = str_replace(
                '</figure>',
                '<figcaption class="wp-element-caption">' . $ai_notice . '</figcaption></figure>',
                $block_content
            );
        }

        return $block_content;
    }

    /**
     * Add AI notice to featured images on single post/page views
     */
    public function add_featured_image_notice($html, $post_id, $post_thumbnail_id, $size, $attr) {
        // Only add notice on single post/page views
        if (!is_singular()) {
            return $html;
        }

        // Check if the featured image is AI-generated
        $is_ai = get_post_meta($post_thumbnail_id, self::META_KEY, true);

        if (!$is_ai) {
            return $html;
        }

        // Create the AI notice
        $ai_notice = '<p class="ai-generated-notice featured-image-notice">' . esc_html__('Generated with artificial intelligence', 'ai-image-marker') . '</p>';

        // Wrap the image and notice in a container
        $output = '<div class="featured-image-container ai-generated-featured">';
        $output .= $html;
        $output .= $ai_notice;
        $output .= '</div>';

        return $output;
    }

    /**
     * Enqueue frontend styles
     */
    public function enqueue_frontend_styles() {
        $css = "
        .ai-generated-notice {
            display: block;
            font-size: 0.9em;
            font-style: italic;
            color: #666;
            float: right;
            clear: right;
            margin: 0 0 8px 12px;
            text-align: right;
        }

        .ai-generated-notice::before {
            /*content: '🤖 ';*/
            margin-right: 4px;
        }

        .ai-generated-caption .ai-generated-notice {
            display: inline-block;
        }

        /* Classic Editor caption styling */
        .wp-caption .ai-generated-notice {
            float: right;
            clear: right;
            margin: 0 0 8px 12px;
        }

        .wp-caption .wp-caption-text {
            overflow: auto;
        }

        .wp-block-image.ai-generated-caption figcaption {
            overflow: auto;
        }

        /*.wp-block-image.ai-generated-caption {
            border-left: 3px solid #e0e0e0;
            padding-left: 12px;
        }*/

        .ai-generated-image {
            position: relative;
        }

        /* Ensure notice is visible in block editor images */
        .wp-block-image figcaption .ai-generated-notice {
            display: block;
            float: right;
            clear: right;
        }

        /* Featured image AI notice styling */
        .featured-image-container {
            margin-bottom: 1.5em;
        }

        /*.featured-image-container.ai-generated-featured {
            border-left: 3px solid #e0e0e0;
            padding-left: 12px;
        }*/

        .featured-image-notice {
            float: right;
            clear: right;
            margin: 8px 0 0 12px;
            text-align: right;
            font-size: 0.9em;
            font-style: italic;
            color: #666;
        }

        /*.featured-image-notice::before {
            content: '🤖 ';
            margin-right: 4px;
        }*/
        ";

        wp_add_inline_style('wp-block-library', $css);

        // Fallback: register and enqueue our own stylesheet if block library isn't loaded
        wp_register_style('ai-image-marker', false);
        wp_enqueue_style('ai-image-marker');
        wp_add_inline_style('ai-image-marker', $css);
    }

    /**
     * Enqueue admin scripts
     */
    public function enqueue_admin_scripts($hook) {
        if ($hook === 'upload.php' || $hook === 'post.php' || $hook === 'post-new.php') {
            wp_enqueue_script(
                'ai-image-marker-admin',
                plugin_dir_url(__FILE__) . 'admin.js',
                array('jquery'),
                self::VERSION,
                true
            );
        }
    }
}

// Initialize the plugin
AI_Image_Marker::get_instance();

/**
 * Helper function to check if an image is AI-generated
 *
 * @param int $attachment_id The attachment ID
 * @return bool True if AI-generated, false otherwise
 */
function is_ai_generated_image($attachment_id) {
    return (bool) get_post_meta($attachment_id, AI_Image_Marker::META_KEY, true);
}

/**
 * Helper function to display AI notice for an image
 *
 * @param int $attachment_id The attachment ID
 * @return string HTML output of AI notice if applicable
 */
function get_ai_image_notice($attachment_id) {
    if (is_ai_generated_image($attachment_id)) {
        return '<span class="ai-generated-notice">' . esc_html__('Generated with artificial intelligence', 'ai-image-marker') . '</span>';
    }
    return '';
}
