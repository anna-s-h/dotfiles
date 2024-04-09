{
    plugins.bufferline = {
        enable = true;
    };
    plugins.lualine = {
        enable = true;
    };
    plugins.undotree = {
        enable = true;
    };
    plugins.telescope = {
        enable = true;
    };
    plugins.treesitter = {
        enable = true;
        indent = true;
#folding = true;
    };
    plugins.fugitive.enable = true;
    plugins.lsp = {
        enable = true;
        servers = {
            nixd.enable = true;
#rust-analyzer.enable = true;
        };
        keymaps = {
            lspBuf = {
                "gd" = "definition";
                "gD" = "references";
                "gt" = "type_definition";
                "gi" = "implementation";
                "K" = "hover";
            };
        };
    };
    plugins.luasnip = {
        enable = true;
    };
    plugins.cmp = {
        enable = true;
        settings.mapping = {
            #"<C-d>" = "cmp.mapping.scroll_docs(-4)";
            #"<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            #"<C-e>" = "cmp.mapping.close()";
            "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-l>" = "cmp.mapping.confirm({ select = true })";
        };
    };
}
