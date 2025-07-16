{ osConfig, ... }:
{
  services.swayosd.enable = true;
  # Doesn't work currently but maybe fixed in v0.2.1
  xdg.configFile."swayosd/style.css".text = ''
    @define-color base ${osConfig.theme.base.hex};
    @define-color text ${osConfig.theme.text.hex};
    @define-color accent ${osConfig.theme.${osConfig.accent}.hex};

    window#osd {
        border-radius: 999px;
        border: none;
        background: alpha(@base, 0.5);
    }
    window#osd #container {
        margin: 16px;
    }
    window#osd image, window#osd label {
        color: @accent;
    }
    window#osd progressbar:disabled, window#osd image:disabled {
        opacity: 0.5;
    }
    window#osd progressbar {
        min-height: 6px;
        border-radius: 999px;
        background: transparent;
        border: none;
    }
    window#osd trough {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: alpha(@text, 0.5);
    }
    window#osd progress {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: @text;
    }
  '';
}
