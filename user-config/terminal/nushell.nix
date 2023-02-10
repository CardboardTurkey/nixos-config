{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.nushell = {
      enable = true;
      extraEnv = ''
        let-env MANPAGER = "sh -c 'col -bx | bat --theme Dracula -l man -p'"
        let-env PATH = ($env.PATH | append ~/.cargo/bin)
      '';
    };
  };
}
