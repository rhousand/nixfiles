{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rhousand";
  home.homeDirectory = "/home/rhousand";
  home.packages = with pkgs; [
    libsForQt5.neochat
    vscode-fhs.all
    btop
    slack
    firefox
    dig
    zoom-us
  ];
  programs = {
    tmux = {
      enable = true;
      terminal = "xterm-256color";
      historyLimit = 406000;
      prefix = "C-b";
      baseIndex = 1;
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        source ${pkgs.python39Packages.powerline}/share/tmux/powerline.conf
        setw -g xterm-keys on
        set -sg repeat-time 600
        set -s focus-events on
        set -q -g status-utf8 on
        setw -q -g utf8 on
        setw -g automatic-rename on
        set -g renumber-windows on
        set -g set-titles on
        set -g set-titles-string '#H:#S.#I.#P #W #T'
        set -g display-panes-time 800
        set -g display-time 1000
        set -g status-interval 10
        set -g visual-bell on
        set -g bell-action any
        setw -g monitor-activity on
        set -g visual-activity on
        bind - split-window -v
        bind \\ split-window -h
        bind C-f command-prompt -p find-session 'switch-client -t %%'
        bind -r h select-pane -L  # move left
        bind -r j select-pane -D  # move down
        bind -r k select-pane -U  # move up
        bind -r l select-pane -R  # move right
        bind > swap-pane -D       # swap current pane with the next one
        bind < swap-pane -U       # swap current pane with the previous one
        bind -r H resize-pane -L 2
        bind -r J resize-pane -D 2
        bind -r K resize-pane -U 2
        bind -r L resize-pane -R 2
      '';
    };
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ 
        vim-airline 
        vim-nix
      ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
        colorscheme desert
      '';
    };
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        extraConfig = ''
          SHOW_AWS_PROMPT=true
        '';
        plugins = [
          "git"
          "sudo"
          "docker"
          "terraform"
          "systemadmin"
          "vi-mode"
          "aws"
        ];
      };
    };
    git = {
      enable = true;
      userName = "Ryan Housand";
      userEmail = "rhousand@gmail.com";
      aliases = {
        st = "status";
        cm = "commit -m";
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
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
