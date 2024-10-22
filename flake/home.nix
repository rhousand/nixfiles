{ pkgs, ... }: 
{
  imports = [
    ./modules/direnv.nix
    ./modules/tmux.nix
    ./modules/vim.nix
    ./modules/zsh.nix
    ./modules/darwin.nix
#    ./modules/doom-emacs.nix
  ];
  home.username = "rhousand";
  home.packages = with pkgs; [
    automake
    awscli2
    bat
    bitwarden-cli
    bottom
    btop
    cloc
    cmake
    dbeaver
    difftastic
    dig
    docker
    du-dust
    dua
    eza
    fd
    findutils
    fzf
    gitkraken
    gnupg
    go
    heroku
    ipcalc
    ispell
    iterm2
    jq
    go-task
    libtool
    libvterm-neovim
    m-cli # Useful MacOS CLI commands
    neofetch
    nerd-font-patcher
    nerdfonts
    nmap
    nodejs
    notmuch
    nvd  # Nix package version tool $ nvd diff /nix/var/nix/profiles/system-{14,15}-link
    python39 # Needed for Treemacs
    rename
    ripgrep
    sbcl # Lisp RPEL
    silver-searcher # This is the ag command
    ssm-session-manager-plugin
    stow
    syncthing
    tealdeer  # tldr
    tree
    #vscode-with-extensions
    #vscodium
    #yabai
    magic-wormhole
    zip
    zoxide
  ];
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs29;
      extraPackages = epkgs: [
        epkgs.vterm
        epkgs.slime
        epkgs.consult
      ];
      extraConfig = '' (setq standard-indent 2) '';
    };
    neovim = {
      defaultEditor = true;
      enable = true;
#      profiles.rhjun = {
#
#        bookmarks = [
#          {
#            name = "prod-pop";
#            tags = [ "pop" "Prod" "Gladstone" ];
#            keyword = "prod";
#            url = "https://prod-pop.gladstone53.com/";
#          }
#        ];
#      };
    };
    git = {
      enable = true;
      userName = "Ryan Housand";
      userEmail = "rhousand@gmail.com";
      ignores = [
        ".DS_Store"
      ];
      aliases = {
        st = "status";
        cm = "commit -m";
        aa = "add -A .";
        br = "branch";
        c = "commit -S";
        ca = "commit -S --amend";
        cb = "checkout -b";
        co = "checkout";
        d = "diff";
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
