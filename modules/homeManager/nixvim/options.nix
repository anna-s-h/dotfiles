{
  config.opts = {

    number = true;
    relativenumber = true;

    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    smartindent = false;
    autoindent = true;
    wrap = false;

    undofile = true;
    undodir = "/home/solanum/undo/"; #TODO make dynamic
    incsearch = true;
    termguicolors = true; #enable full colorspace

    scrolloff = 8;
    #signcolumn = "number";
    signcolumn = "auto";
    
    foldcolumn = "1";
    fillchars = "fold: ,foldopen:,foldsep: ,foldclose:";
    foldlevelstart = 999;

    updatetime = 500;

    timeout = false;
  };
}

