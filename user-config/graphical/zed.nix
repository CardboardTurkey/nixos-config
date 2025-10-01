{
  pkgs,
  osConfig,
  ...
}:
{
  home.packages = with pkgs; [
    openssl
    pkg-config
  ];
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "git-firefly"
      "html"
      "nix"
      "toml"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
      rustfmt
      rust-analyzer
      openssl
      pkg-config
    ];

    ## this is integrated Lazygit into Zed
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          alt-g = [
            "task::Spawn"
            { "task_name" = "start lazygit"; }
          ];
        };
      }
    ];
    ## everything inside of these brackets are Zed options.
    userSettings = {
      features = {
        copilot = false;
        inline_completion_provider = "none";
      };
      autosave = "on_focus_change";
      auto_update = false;
      base_keymap = "VSCode";
      load_direnv = "shell_hook";
      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
      hour_format = "hour24";
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "${osConfig.emulator}";
        };
        font_family = "JetBrainsMono Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };
      vim_mode = false;
      show_whitespaces = "all";
    };
  };
}
