{
  imports = [ "${builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops" ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../files/secrets.yaml;
  home-manager.users.kiran = {
    home.file.".sops.yaml".text = ''
      keys:
        - &kestrel age1rjal6afqld20xmwndrnqj96svm7fv2gz0chq660m6dm0tsjjrdsqz7m7p9
        - &wren age1rr707w76smu6gwph09f3khk7ef35xakm9n9mllhpgkuedpwh7qzsnvqtsm
        - &finch age1llxfjuxxq6ndmdgshr8wepkzlm3s3gf2qtu5axny43pcrp49wp5s6awpj5
      creation_rules:
        - path_regex: .*\.yaml$
          key_groups:
          - age:
            - *kestrel
            - *wren
            - *finch
            pgp:
            - 5B2FC8FC2BCF1A58885D6C92B67BBEB336616007
    '';
  };
}
