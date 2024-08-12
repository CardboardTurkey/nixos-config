{ config, ... }: {
  home-manager.users.kiran = {
    home.file.".sops.yaml".text = ''
      creation_rules:
        - path_regex: .*\.yaml$
          key_groups:
          - age:
            - ${config.kestrel_host_age}
            - ${config.harrier_host_age}
            - ${config.wren_host_age}
            - ${config.osprey_host_age}
            pgp:
            - ${config.pgp_enc}
    '';
  };
}
