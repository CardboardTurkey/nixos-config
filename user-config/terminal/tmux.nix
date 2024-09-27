{ osConfig, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = osConfig.emulator;
    historyLimit = 500000;
    extraConfig = ''
      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Make sure home and end work
      bind-key -n Home send Escape "OH"
      bind-key -n End send Escape "OF"
    '';
  };
}
