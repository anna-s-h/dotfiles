{
    config.options = {

        number = true;
        relativenumber = true;

        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;

        smartindent = true;
        wrap = false;

        #undodir = ''os.getenv("HOME") .. "/.vim/undodir"'' #fix to nix syn
        #undofile = true;

        incsearch = true;

        termguicolors = true; #what?

        scrolloff = 8;
        signcolumn = "number";

        updatetime = 500;
    };
}

