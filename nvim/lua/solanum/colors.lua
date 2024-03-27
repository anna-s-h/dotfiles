require('ayu').setup({
 ayucolor="mirage",
 disable_background = true
})

vim.cmd.colorscheme("ayu")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
