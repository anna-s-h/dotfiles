{ pkgs, ... } : {
  plugins = {

    bufferline = {
      enable = true;
    };

    lualine = {
      enable = true;
      settings = {
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
    };

    undotree = {
      enable = true;
    };

    telescope = {
      enable = true;
    };

    fugitive.enable = true;

    web-devicons.enable = true;

    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        cssls.enable = true;
        ts_ls.enable = true;
        jsonls.enable = true;
        qmlls.enable = true;
        #gdscript.enable = true;
        #rust_analyzer = {
        #  enable = true;
        #  installRustc = false;
        #  installCargo = false;
        #  extraOptions = {
        #    check.command = "cargo check";
        #    CARGO_TARGET_DIR = "/tmp/rust-analyzer";
        #  };
        #};
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
     
    #rustaceanvim = {
    #  enable = true;
    #  settings = {
    #    server = {
    #      default_settings = {
    #        rust-analyzer = {
    #          installCargo = false;
    #          installRustc = false;
    #          cargo = {
    #            allFeatures = true;
    #          };
    #          check = {
    #            command = "cargo check";
    #          };
    #          inlayHints = {
    #            lifetimeElisionHints = {
    #              enable = "always";
    #            };
    #          };
    #        };
    #      };
    #      standalone = false;
    #    };
    #  };
    #};

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
        "<C-Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<C-Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<C-Right>" = "cmp.mapping.confirm({ select = true })";
      };
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };

    yazi = {
      enable = true;
    };

    hardtime = {
      enable = false;
      settings.disableMouse = false;
    };

    nvim-ufo = {
      enable = true;
      settings.provider_selector = ''
        function(bufnr, filetype, buftype) return { 'lsp', 'indent' } end
      '';
    };

    dap.enable = true;

    vim-surround.enable = true;

    colorizer.enable = true;

    #quickfix? bqf? trouble?

  };

  extraPlugins = with pkgs.vimPlugins; [
    statuscol-nvim
    transparent-nvim
  ];
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
