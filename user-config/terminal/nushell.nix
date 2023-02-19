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
      '';
      configFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_config.nu";
        sha256 = "06ang82gsim7z113768011wnrpx10fr2vg8c9cizw08dmjwsg620";
      };
      envFile.source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu";
        sha256 = "0p9wk4gg16kzlj9qv6mxrcpqmc8yjp2r6l7jqfn6nqssivpvmmm4";
      };
      extraConfig = ''
        use ${nu_scripts}/share/nu_scripts/git/git.nu *
        use ${nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
      '';
    };
  };
}
