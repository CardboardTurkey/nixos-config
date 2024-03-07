{ config, ... }:

let
  eyegog_if = "eyegog";
in

{
  imports = [ ../user-config/other/sops.nix ];

  sops.secrets."ayden_vpn/private_key" = { };
  networking.wg-quick.interfaces.${eyegog_if} = {
    address = [ "172.16.41.4/32" ];
    privateKeyFile = config.sops.secrets."ayden_vpn/private_key".path;
    postUp = "resolvectl dns ${eyegog_if} 10.10.4.254; resolvectl domain ${eyegog_if} eyegog.co.uk";
    peers = [{
      endpoint = "88.97.110.231:5765";
      publicKey = "rmIJKNXx9zWnMJh2e1Pbrp2ipkAyi52cYdKG0JKdf1A=";
      allowedIPs = [ "10.10.0.0/16" ];
    }];
  };
}
