{config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      prezto.tmux.autoStartLocal = true;
      shellAliases = {
        nconf = "cd ~/.config/";
        ngen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nupdate = "pushd ~/.config
                   nix build --recreate-lock-file .#darwinConfigurations.TD-C02FG1PYMD6N.system
                   popd";
        flk = "pushd ~/.config
               # nix run 'https://flakehub.com/f/DeterminateSystems/flake-checker/*.tar.gz' || \
               nix build .#darwinConfigurations.TD-C02FG1PYMD6N.system && \
               ./result/sw/bin/darwin-rebuild switch --flake .
               popd";
        fz = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind shift-up:preview-page-up,shift-down:preview-page-down";
        fvim = "vim $(fz)";
        vim = "nvim";
        vi = "nvim";
        please = "sudo";
        pdev = "task pdev";
        adev = "task adev";
        odev = "task odev";
        ptest = "task ptest";
        atest = "task atest";
        otest = "task otest";
        pprod = "task pprod";
        aprod = "task aprod";
        oprod = "task oprod";
        pbpro = "task pbpro";
        abpro = "task abpro";
        obpro = "task obpro";
        pstage = "task pstage";
        astage = "task astage";
        ostage = "task ostage";
        awsnon = "task awsnon";
        awsprod = "task awsprod";
        myzoom = "echo https://us02web.zoom.us/j/3648990324 | pbcopy";
        cainszoom = "echo 'https://us02web.zoom.us/j/7341282523?pwd=TkZLeU1MY2d5eUpqeTJ5WUJTRHlVUT09' | pbcopy";
        tfwl = "terraform workspace list";
        tfv = "terraform -version";
        tfmv = "cat .terraform/modules/modules.json | jq -r '.Modules[]'";
        ec = "open /Applications/Emacs.app --args --debug-init";
        ls = "ls --color";
        s = "ssh";
        g = "git";
        gs = "git status -s";
        ga = "git add";
        gl = "git log --pretty=format:'%C(yellow)%h %Cred%ar %Cblue%an%Cgreen%d %Creset%s' --date=short";
        gd = "git diff";
        gp = "git pull";
        gps = "git push";
        gcm = "git commit";
        gco = "git checkout";
        gcl = "git clone";
        d = "docker";
        dc = "docker compose";
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        findport = "sudo lsof -iTCP -sTCP:LISTEN -n -P | grep";
        awslogin = "aws sso login --profile DBAdmin-Prod-502813388601";
        awshosts="aws ec2 describe-instances --query \"Reservations[*].Instances[*].{InstanceID:InstanceId,Name:Tags[?Key=='Name']|[0].Value,PrivateIP:PrivateIpAddress,Status:State.Name}\" --filters Name=instance-state-name,Values=running --output table | cat";
        xnon="export AWS_PROFILE=AdministratorAccess-141788785841";
        xprod="export AWS_PROFILE=AdministratorAccess-502813388601";
      };
      initExtra = ''
        myssm() {
          ID=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].{InstanceID:InstanceId,Name:Tags[?Key=='Name']|[0].Value,PrivateIP:PrivateIpAddress,Status:State.Name}" --filters Name=instance-state-name,Values=running --output text | fzf-tmux -p -w 75% |awk '{printf $1}')
          echo Accessing $ID EC2 instance
          #read "ID?Choose an Instance ID to access via SSM? "
          aws ssm start-session --target $ID
        }
        drrm() {
          if [ -n "$1" ]
          then
            docker stop $1
            docker rm $1
          else
            echo "Container name required"
          fi
        }
        repo() {
          if [ -n "$1" ]
          then
            echo moving to repo  $1
            cd  ~/Documents/repos/$1/
          else
            cd ~/Documents/repos
            cd $(fd -t d -d 1|fzf-tmux -p --reverse)
          fi
       } 
        repos() {
          if [ -n "$1" ]
          then
            echo moving to repo  $1
            cd  ~/Documents/repos/$1/
          else
            ls ~/Documents/repos
          fi
        }
        # Egress IP
        myip() {
          RETURN_STRING=$(curl --silent --url "www.ifconfig.me" --write-out "\nHTTP_CODE:%{http_code}:" | tr "\n" " ")
          IP="''${RETURN_STRING%% *}"
          echo $IP
        }
      '';
      
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        extraConfig = ''
          SHOW_AWS_PROMPT=true
          DISABLE_FZF_AUTO_COMPLETION="false"
          DISABLE_FZF_KEY_BINDINGS="false"
          FZF_BASE=$(fzf-share)
          source "$(fzf-share)/completion.zsh"
          export FPATH=~/.task:$FPATH
          source "$(fzf-share)/key-bindings.zsh"
          PROMPT="$PROMPT\$(vi_mode_prompt_info)"
          RPROMPT="\$(tf_prompt_info)\$(vi_mode_prompt_info)$RPROMPT"
        '';
        plugins = [
          "git"
          "sudo"
          "fzf"
          "docker"
          "terraform"
          "systemadmin"
          "vi-mode"
          "aws"
          "zoxide"
        ];
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
