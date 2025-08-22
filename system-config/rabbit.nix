{ config, ... }:
{
  # Authentication
  #
  # It appears default user guest (password guest) can't connect remotely. Get
  # cookie from `/var/lib/rabbitmq/.erlang.cookie`.
  #
  # Create a new user with all permissions:
  #
  # ```console
  # > rabbitmqctl --erlang-cookie YOUR_COOKIE add_user kiran PASSWORD
  # > rabbitmqctl --erlang-cookie YOUR_COOKIE set_user_tags kiran administrator
  # > rabbitmqctl --erlang-cookie YOUR_COOKIE set_permissions -p / kiran ".*" ".*" ".*"`
  # ```

  services.rabbitmq = {
    enable = true;
    listenAddress = "100.103.252.84";
  };
  networking.firewall.allowedTCPPorts = [ config.services.rabbitmq.port ];
}
