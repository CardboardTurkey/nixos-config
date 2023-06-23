{ pkgs, ... }:
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
        sha256 = "17b5n1dpqwbfzqfmii7b8qnbd585aimhp0kkq2m89hx1yk0qhjsa";
      };
      envFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu";
        sha256 = "17r6skzbdy2irmx1n77289prdsxky05bflfhv98z9f0hrcc4p9ka";
      };
      extraConfig = ''
        use ${pkgs.nu_scripts}/share/nu_scripts/modules/git/git.nu *
        use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
        '';
    };
  };
}
