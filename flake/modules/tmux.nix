{config, pkgs, ... }:
{
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
      # Start of Copy / Past config
        set -g mouse on
        bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
        bind -n WheelDownPane select-pane -t= \; send-keys -M
        bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
        bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
        bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down

        # To copy, left click and drag to highlight text in yellow,
        # once you release left click yellow text will disappear and will automatically be available in clibboard
        # # Use vim keybindings in copy mode
        setw -g mode-keys vi
        # Update default binding of `Enter` to also use copy-pipe
        unbind -T copy-mode-vi Enter
        bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      # End of Copy / Past config
        set -g xterm-keys on
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
  };
}
