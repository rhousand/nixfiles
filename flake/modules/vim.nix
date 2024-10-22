{config, pkgs, ... }:
{
  programs = {
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-nix
        vim-yaml
        vim-terraform
      ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=v
        syntax on
        " Use CRL+y to copy visually selected to Mac clipboard via pbcopy
        vmap <C-y> :w !pbcopy<CR><CR>
        colorscheme desert
        set t_Co=256
        " Return to last edit position when opening files (You want this!)
        autocmd BufReadPost *
             \ if line("'\"") > 0 && line("'\"") <= line("$") |
             \   exe "normal! g`\"" |
             \ endif

        filetype plugin indent on
        " On pressing tab, insert 2 spaces
        set expandtab
        " show existing tab with 2 spaces width
        set tabstop=2
        set softtabstop=2
        " when indenting with '>', use 2 spaces width
        set shiftwidth=2
      '';
    };
  };
}
