{ pkgs }:
pkgs.writeShellScriptBin "my-test-script" ''
  echo "hellow World" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
