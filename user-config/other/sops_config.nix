{ osConfig, ... }:
{
  home.file.".sops.yaml".text = ''
    creation_rules:
      - path_regex: .*\.yaml$
        key_groups:
        - age:
          - ${osConfig.kestrel_host_age}
          - ${osConfig.harrier_host_age}
          - ${osConfig.wren_host_age}
          - ${osConfig.osprey_host_age}
          pgp:
          - ${osConfig.pgp_enc}
  '';
}
