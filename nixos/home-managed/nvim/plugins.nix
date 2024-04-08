{
  plugins.bufferline = {
    enable = true;
  };
  plugins.undotree = {
    enable = true;
    #vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
  };
  plugins.telescope = {
    enable = true;
    #local builtin = require('telescope.builtin')
    #vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    #vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
    #vim.keymap.set('n', '<leader>fs', function()
    #    builtin.grep_string({search=vim.fn.input("Grep > ")})
    #end)
  };
  plugins.treesitter = {
    enable = true;
    indent = true;
    folding = true;
  };
  plugins.fugitive.enable = true;
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;
      #rust-analyzer.enable = true;
    };
    #keybinds missing
  };
  #deprecated
  #plugins.nvim-cmp = {
  #  enable = true;
  #  autoEnableSources = true;
  #  sources = [
  #    {name = "nvim_lsp";}
  #    {name = "path";}
  #    {name = "buffer";}
  #  ];
  #};
}
