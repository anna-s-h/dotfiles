{
    globals.mapleader = " ";

    keymaps = [
        # file explorer in editor
        {  mode = "n";
            key = "<leader>fe";
            action = "vim.cmd.Ex";
            lua = true;
        }

        # go to normal mode from insert
        {  mode = ["i" "v"];
            key = "<M-Space>";
            action = "<Esc>";
        }

        # use system clipboard
        {  mode = ["i" "v"];
            key = "<leader>y";
            action = "\"+y";
        }{ mode = "n";
            key = "<leader>p";
            action = "\"+p";
        }{ mode = "n";
            key = "<leader>Y";
            action = "\"+Y";
        }

        # format whole file
        {  mode = "n";
            key = "<leader>=";
            action = "vim.lsp.buf.format";
            lua = true;
        }

        #view git (with tpope?)
        {  mode = "n";
            key = "<leader>g";
            action = "vim.cmd.Git";
            lua = true;
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
