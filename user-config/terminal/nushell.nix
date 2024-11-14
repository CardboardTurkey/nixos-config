{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    extraEnv = ''
      $env.MANROFFOPT = "-c" # Needed for bat-manpager integration
      $env.MANPAGER = "sh -c 'col -bx | bat --theme Dracula -l man -p'"
      $env.PATH = ($env.PATH | split row (char esep) | append '~/.cargo/bin')

      # The prompt indicators are environmental variables that represent
      # the state of the prompt
      $env.PROMPT_INDICATOR = ""
      $env.PROMPT_INDICATOR_VI_INSERT = ": "
      $env.PROMPT_INDICATOR_VI_NORMAL = "〉"
      $env.PROMPT_MULTILINE_INDICATOR = "::: "
    '';
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
    
      use ${pkgs.nu_scripts}/share/nu_scripts/modules/git/git.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
    '';
  };
}
