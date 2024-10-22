# SPDX-License-Identifier: MIT
# https://github.com/reckenrode/nixos-configs/blob/main/modules/unit/co/copy-apps/module.nix

{ config, lib, pkgs, ... }:

let
  appsSrc = if config ? home
    then "$newGenPath/home-path/Applications"
    else config.system.build.applications + /Applications;

  baseDir = if config ? home
    then "${config.home.homeDirectory}/Applications/Home Manager Apps New"
    else "/Applications/Nix Apps";

  copyScript = lib.optionalString (config ? system) ''
    echo 'Setting up /Applications/Nix Apps...' >&2
  '' + ''
    appsSrc="${appsSrc}"
    if [ -d "$appsSrc" ]; then
      baseDir="${baseDir}"
      rsyncFlags=(
        --archive
        --checksum
        --chmod=-w
        --copy-unsafe-links
        --delete
        --no-group
        --no-owner
      )
      $DRY_RUN_CMD mkdir -p "$baseDir"
      $DRY_RUN_CMD ${lib.getBin pkgs.rsync}/bin/rsync \
        ''${VERBOSE_ARG:+-v} "''${rsyncFlags[@]}" "$appsSrc/" "$baseDir"
    fi
  '';

  isHomeManager = lib.hasAttr "hm" lib;
in
{
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  config = lib.mkIf pkgs.stdenv.isDarwin (
    lib.optionalAttrs isHomeManager {
      home.activation.copyApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] copyScript;
    } // lib.optionalAttrs (!isHomeManager) {
      system.activationScripts.applications.text = lib.mkForce copyScript;
    }
  );
}
##{
##  config,
##  pkgs,
##  lib,
##  system,
##  ...
##}: {
##  # Disable built-in symlinking of the Home Manager Applications directory.
##  disabledModules = ["targets/darwin/linkapps.nix"];
##  # Add a custom mkalias based thing cribbed from:
##  #   https://github.com/nix-community/home-manager/issues/1341#issuecomment-1446696577
##  # but using mkalias as in
##  #   https://github.com/reckenrode/nixos-configs/commit/26cf5746b7847ec983f460891e500ca67aaef932?diff=unified
##  # instead; latter found via
##  # via
##  #   https://github.com/nix-community/home-manager/issues/1341#issuecomment-1452420124
##  home.activation.aliasApplications =
##    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
##    (let
##      apps = pkgs.buildEnv {
##        name = "home-manager-applications";
##        paths = config.home.packages;
##        pathsToLink = "/Applications";
##      };
##    in
##      lib.hm.dag.entryAfter ["linkGeneration"] ''
##        app_path="$HOME/Applications/Home Manager Apps"
##        tmp_path="$(mktemp -dt "home-manager-apps.XXXXXXXXXX")" || exit 1
##
##        for app in \
##          $(find "${apps}/Applications" -maxdepth 1 -type l)
##        do
##          real_app="$(realpath "$app")"
##          app_name="$(basename "$app")"
##          $DRY_RUN_CMD ${inputs.mkalias.outputs.apps.${system}.default.program} "$real_app" "$tmp_path/$app_name"
##        done
##
##        $DRY_RUN_CMD rm -rf "$app_path"
##        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
##      '');
##}
