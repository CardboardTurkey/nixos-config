{ config, pkgs, ... }:
{
  allowed_unfree = [
    "cuda_cudart"
    "libcublas"
    "cuda_cccl"
    "cuda_nvcc"
  ];

  networking = {
    firewall.allowedTCPPorts = [
      config.services.qdrant.settings.service.http_port
      config.services.qdrant.settings.service.grpc_port
    ];
    hosts = {
      "127.0.0.1" = [ "chromadb.local" ];
    };
  };

  services = {
    ollama = {
      enable = true;
      openFirewall = true;
      host = config.tailscaleAddress;
      package = pkgs.ollama-cuda;
      loadModels = [ "phi4-mini" ];
      acceleration = "cuda";
      environmentVariables = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
    qdrant = {
      enable = true;
      settings = {
        service = {
          # Temporary. Remove this once chatbot server is running on kestrel.
          host = config.tailscaleAddress;
          http_port = 6333;
          grpc_port = 6334;
        };
      };
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."chromadb.local" = {
        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString config.services.chromadb.port}";
        };
      };
    };
  };
}
