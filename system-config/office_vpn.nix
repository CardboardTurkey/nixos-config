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

  environment.systemPackages = [
    (pkgs.writeScriptBin "vpnup" "pass -c vpn/sigma && nmcli c u sigma; sudo ip route delete default dev tun0")
  ];
}
