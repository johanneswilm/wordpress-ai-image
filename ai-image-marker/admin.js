jQuery(document).ready(function($) {
    // Populate quick edit fields with current values
    var $wp_inline_edit = inlineEditPost.edit;
    
    inlineEditPost.edit = function(id) {
        // Call original function
        $wp_inline_edit.apply(this, arguments);
        
        var $post_id = 0;
        if (typeof(id) == 'object') {
            $post_id = parseInt(this.getId(id));
        }
        
        if ($post_id > 0) {
            // Get the row
            var $edit_row = $('#edit-' + $post_id);
            var $post_row = $('#post-' + $post_id);
            
            // Get the AI generated status from the column
            var $ai_column = $post_row.find('.column-ai_generated');
            var is_ai = $ai_column.find('.dashicons-yes-alt').length > 0;
            
            // Set the checkbox
            $edit_row.find('input[name="ai_generated"]').prop('checked', is_ai);
        }
    };
});