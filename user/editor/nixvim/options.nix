{
  programs.nixvim = {
    globals = {
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0;
      mapleader = " ";
    };

    opts = {
      relativenumber = true;
      number = true;

      swapfile = false;
      undofile = true;

      incsearch = true;
      inccommand = "split";
      ignorecase = true;
      smartcase = true;

      scrolloff = 8;

      splitbelow = true;
      splitright = true;

      autoindent = true;
      wrap = false;


      expandtab = true;
#     tabstop = 4;
#     shiftwidth = 4;
      
      virtualedit = "block";

      termguicolors = true;
    };
  };
}
