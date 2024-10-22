{ config, pkgs, callPackage, ... }:

let
  my-test-script = import ./modules/my-test-script.nix { inherit pkgs; };
  brave-darwin = import ./modules/brave.nix { inherit pkgs; };
in
{
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = 
    [ 
      #brave-darwin
      my-test-script
      pkgs.vim
    ];
  users.users.rhousand = {
    name = "rhousand";
    home = "/Users/rhousand";
  };

  nixpkgs.config.allowUnsupportedSystem = true;
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  fonts.fontDir.enable = false;
  fonts.fonts = [ pkgs.nerdfonts ];
  
  # nix.package = pkgs.nix;
 # services.emacs.package = pkgs.emacs-unstable;
 # nixpkgs.overlays = [
 #   (import (builtins.fetchTarball {
 #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
 #     sha256 = "0lv0k1f6rrlym43l6bz14dcc3sz3pmxmklc82qkw98wrrb4vz4lv";
 #   }))
 # ];
  services.emacs.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
  nix = {
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };


  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
