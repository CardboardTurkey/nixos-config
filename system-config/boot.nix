{
  # 22-06-29: Whether to enable systemd in initrd. Note: This is in very early
  # development and is highly experimental. Most of the features NixOS
  # supports in initrd are not yet supported by the intrd generated
  # with this option.
  boot.initrd.systemd.enable = true;

  # Enable binfmt emulation of riscv.
  boot.binfmt.emulatedSystems = [ "riscv64-linux" ];
}
