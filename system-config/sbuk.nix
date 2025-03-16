{ config, ... }:

let
  sbuk_if = "sbuk";
  wg =
    if (config.hostname == "Osprey") then
      {
        key = "sbuk/admin_key";
        address = "172.16.1.2/32";
        peer = "3TKJwAaLM7Q32cTEMT4Mb91sDGnmnq5wjphgOxf9+kY=";
        endpoint = "9401";
      }
    else if (config.hostname == "Harrier") then
      {
        key = "sbuk/user_key";
        address = "172.16.3.2/32";
        peer = "Ekq80c8P4qky3DhepP5dFFU/Dxp1p2knaVUuC9xyUCs=";
        endpoint = "5498";
      }
    else
      "";
in
{
  imports = [ ../system-config/sops.nix ];
  sops.secrets."${wg.key}" = { };
  networking.wg-quick.interfaces.${sbuk_if} = {
    address = [ "${wg.address}" ];
    privateKeyFile = config.sops.secrets."${wg.key}".path;
    postUp = "resolvectl dns ${sbuk_if} 172.16.1.254; resolvectl domain ${sbuk_if} smoothbrained.co.uk";
    # dns = [ "172.16.1.254" ];
    peers = [
      {
        endpoint = "128.140.103.62:${wg.endpoint}";
        publicKey = "${wg.peer}";
        allowedIPs = [
          "172.16.0.0/16"
        ];
      }
    ];
  };
}
