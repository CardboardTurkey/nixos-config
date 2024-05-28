{ config, ... }: {
  imports = [
    "${
      builtins.fetchTarball
      "https://github.com/Mic92/sops-nix/archive/master.tar.gz"
    }/modules/sops"
  ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../files/secrets.yaml;
  home-manager.users.kiran = {
    home.file.".sops.yaml".text = ''
      creation_rules:
        - path_regex: .*\.yaml$
          key_groups:
          - age:
            - ${config.kestrel_host_age}
            - ${config.harrier_host_age}
            - ${config.wren_host_age}
            pgp:
            - ${config.pgp_enc}
    '';
  };
}
