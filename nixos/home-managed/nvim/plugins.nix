{ pkgs, ... } : {
  plugins = {
    bufferline = {
      enable = true;
    };
    lualine = {
      enable = true;
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff" "diagnostics"];
        lualine_c = ["filename"];
        lualine_x = ["filetype" "encoding"];
        lualine_y = ["searchcount"];
        lualine_z = ["location"];
      };
      globalstatus = true;
      extensions = ["nvim-tree"];
    };
    undotree = {
      enable = true;
    };
    telescope = {
      enable = true;
    };
    treesitter = {
      enable = true;
      indent = true;
#folding = true;
    };
    fugitive.enable = true;
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        cssls.enable = true;
        tsserver.enable = true;
        jsonls.enable = true;
        gdscript.enable = true;
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
    luasnip = {
      enable = true;
    };
    cmp = {
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
    nvim-tree = {
      enable = true;
      view.side = "right";
      hijackCursor = true;
      actions.openFile.quitOnOpen = true;
      actions.windowPicker.enable = true;
      modified.enable = true;
      tab.sync.close = true;
      tab.sync.open = true;
      renderer = {
        icons.gitPlacement = "after";
      };
    };
    transparent = {
      enable = true;
    };
    hardtime = {
      enable = false;
      disableMouse = false;
    };
    nvim-ufo = {
      enable = true;
      providerSelector = ''
        function(bufnr, filetype, buftype) return { 'lsp', 'indent' } end
      '';
    };
    dap.enable = true;
    surround.enable = true;
    #quickfix? bqf? trouble?
  };
  extraPlugins = [pkgs.vimPlugins."statuscol-nvim"];
  extraConfigLua = ''
    local builtin = require("statuscol.builtin")
    require('statuscol').setup({
      setopt = true,
      segments = {
        { text = { '%s' }, click = 'v:lua.ScSa' },
        {
          text = { builtin.lnumfunc, ' ' },
          condition = { true, builtin.not_empty },
          click = 'v:lua.ScLa',
        },
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
      },
    })
  '';
}
