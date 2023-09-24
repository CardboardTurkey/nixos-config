{ config, ... }:
{
  imports = [ ../user-config/other/sops.nix ];
  sops.secrets."ayden_vpn/private_key" = { };
  networking.wg-quick.interfaces.wg0 = {
    address = [ "172.16.41.4/32" ];
    privateKeyFile = config.sops.secrets."ayden_vpn/private_key".path;
    postUp = "resolvectl dns wg0 10.10.4.254; resolvectl domain wg0 eyegog.co.uk";
    peers = [{
      endpoint = "88.97.110.231:5765";
      publicKey = "rmIJKNXx9zWnMJh2e1Pbrp2ipkAyi52cYdKG0JKdf1A=";
      # publicKey = "JNg5WLd7iDDa8Fphxn6bfIBBsGOxbuzIvW62Uro4UiA=";
      allowedIPs = [ "10.10.0.0/16" ];
    }];
  };
}
