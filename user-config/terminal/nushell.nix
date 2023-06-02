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
        sha256 = "0zy12wa9aqdn465x0g0p9ryskm9w7yqpl0jmvid1fd0bgpy50s2a";
      };
      envFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu";
        sha256 = "04iyw67s9jnarhbrkjlpaymgy3jc1kac3p8f4bz1zj73wbnk3c1w";
      };
      extraConfig = ''
        use ${nu_scripts}/share/nu_scripts/git/git.nu *
        use ${nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
        '';
    };
  };
}
