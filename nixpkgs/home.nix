{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rhousand";
  home.homeDirectory = "/home/rhousand";
  home.packages = with pkgs; [
    tmux
  ];
  programs = {
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
