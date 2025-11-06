{ pkgs, ... }:
{
  # Old vpn configuration:
  # services.openvpn.servers = {
  #   officeVPN = {
  #     config = "config /root/nixos/openvpn/officeVPN.conf ";
  #     autoStart = false;
  #     updateResolvConf = true;
  #   };
  # };

  sops.secrets."sigma_vpn" = { };
  environment.systemPackages = [
    (pkgs.writeScriptBin "vpnup" "sudo nmcli c u sigma passwd-file /run/secrets/sigma_vpn; sudo ip route delete default dev tun0")
  ];
}
