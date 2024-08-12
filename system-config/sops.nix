{
  imports = [
    "${
      builtins.fetchTarball
      "https://github.com/Mic92/sops-nix/archive/master.tar.gz"
    }/modules/sops"
  ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../files/secrets.yaml;
}
