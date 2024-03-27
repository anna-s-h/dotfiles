vim.g.mapleader = " "
--file explorer in editor
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
--move selection as lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--improve navigation visibility
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--go to normal mode
vim.keymap.set("i", "<M-Space>", "<Esc>")
vim.keymap.set("v", "<M-Space>", "<Esc>")
--use system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")
--make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")
--replace all instances of word in file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--format whole file
vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
--switch project
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
