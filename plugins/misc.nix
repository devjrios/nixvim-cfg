{
    plugins.oil = {
        enable = true;
        settings = {
            view_options.show_hidden = true;
            default_file_explorer = true;
            use_default_keymaps = true;
            columns = [
                "icon"
                "type"
                "size"
                "permissions"
            ];
            buf_options = {
                buflisted = false;
                bufhidden = "hide";
            };
            delete_to_trash = false;
            skip_confirm_for_simple_edits = true;
            prompt_save_on_select_new_entry = false;
            cleanup_delay_ms = 2000;
            lsp_file_methods = {
                enabled = true;
                timeout_ms = 1000;
                autosave_changes = true;
            };
            constrain_cursor = "editable";
            watch_for_changes = false;
        };
    };
    plugins.undotree.enable = true;
    plugins.cloak.enable = true;
    plugins.web-devicons.enable = true;
    plugins.telescope.enable = true;
}
