{
  globals.mapleader = " ";
  keymaps = [
    # file explorer in editor
    {  mode = "n";
      key = "<leader>fe";
      action = "<cmd>Yazi<cr>";
      #action = "vim.cmd.Ex";
      #action = "vim.cmd.NvimTreeToggle";
      #lua = true;
    }

    # go to normal mode from insert
    {  mode = ["n" "i" "v" "o"];
      key = "<M-Space>";
      action = "<Esc>";
    }

    # clear search from normal
    {  mode = ["n"];
      key = "<Esc>";
      action.__raw = "vim.cmd.nohlsearch";
    }

    # use system clipboard
    {  mode = "n";
      key = "<leader>p";
      action = "\"+p";
    }{ mode = "n";
      key = "<leader>Y";
      action = "\"+Y";
    }{ mode = ["n" "v"];
      key = "<leader>y";
      action = "\"+y";
    }

    # format whole file
    {  mode = "n";
      key = "<leader>=";
      action.__raw = "vim.lsp.buf.format";
    }

    #view git (with tpope?)
    {  mode = "n";
      key = "<leader>g";
      action.__raw = "vim.cmd.Git";
    }

    #view undotree
    { mode = "n";
      key = "<leader>u";
      action.__raw = "vim.cmd.UndotreeToggle";
    }

    #finders
    { mode = "n";
      key = "<leader>ff";
      action.__raw = "require('telescope.builtin').find_files";
    }{ mode = "n";
      key = "<leader>fg";
      action.__raw = "require('telescope.builtin').git_files";
    }{ mode = "n"; # missing ripgrep
      key = "<leader>fs";
      action.__raw = "function() require('telescope.builtin').grep_string({search=vim.fn.input(\"Grep > \")}) end";
    }

    # --move selection as lines
    # vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    # vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
    # --improve navigation visibility
    # vim.keymap.set("n", "<C-d>", "<C-d>zz")
    # vim.keymap.set("n", "<C-u>", "<C-u>zz")
    # vim.keymap.set("n", "n", "nzzzv")
    # vim.keymap.set("n", "N", "Nzzzv")
    # --make file executable
    # vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")
    # --replace all instances of word in file
    # vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
    # --switch project
    # vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
  ];
}
