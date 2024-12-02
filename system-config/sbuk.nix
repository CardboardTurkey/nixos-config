{ config, ... }:

let
  sbuk_if = "sbuk";

in
{
  imports = [ ../system-config/sops.nix ];
  sops.secrets."sbuk/private_key" = { };
  networking.wg-quick.interfaces.${sbuk_if} = {
    address = [ "172.16.1.2/32" ];
    privateKeyFile = config.sops.secrets."sbuk/private_key".path;
    postUp = "resolvectl dns ${sbuk_if} 172.16.1.254; resolvectl domain ${sbuk_if} smoothbrained.co.uk";
    # dns = [ "172.16.1.254" ];
    peers = [
      {
        endpoint = "128.140.103.62:9401";
        publicKey = "3TKJwAaLM7Q32cTEMT4Mb91sDGnmnq5wjphgOxf9+kY=";
        allowedIPs = [
          "172.16.3.0/24"
          "172.16.100.0/24"
          "172.16.99.0/24"
          "172.16.2.0/24"
          "172.16.98.0/24"
          "172.16.1.0/24"
        ];
      }
    ];
  };
}
