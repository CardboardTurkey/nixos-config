{ pkgs, ... }:
let
  nu_scripts = pkgs.local.nu_scripts;
in
{
  home-manager.users.kiran = {
    programs.nushell = {
      enable = true;
      extraEnv = ''
        let-env MANPAGER = "sh -c 'col -bx | bat --theme Dracula -l man -p'"
        let-env PATH = ($env.PATH | append ~/.cargo/bin)

        # The prompt indicators are environmental variables that represent
        # the state of the prompt
        let-env PROMPT_INDICATOR = ""
        let-env PROMPT_INDICATOR_VI_INSERT = ": "
        let-env PROMPT_INDICATOR_VI_NORMAL = "〉"
        let-env PROMPT_MULTILINE_INDICATOR = "::: "
        '';
      configFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_config.nu";
        sha256 = "0kqa49si8xzw2w89ssjm17gw5lzkidnwbcmjalsxdl0l99ikv1n7";
      };
      envFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu";
        sha256 = "102448sgv7g96x6yjkv7v5b92wlgffl5nnz8cba0gj88sjgcba9c";
      };
      extraConfig = ''
        use ${nu_scripts}/share/nu_scripts/git/git.nu *
        use ${nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
        '';
    };
  };
}
