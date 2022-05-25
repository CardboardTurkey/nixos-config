{ config, lib, pkgs, ... }:

let

  lock_cmd = "exec dunstctl set-paused true; exec betterlockscreen -l blur; exec dunstctl set-paused false";

in

{

  environment.systemPackages = with pkgs; [
    betterlockscreen
  ];

  home-manager.users.kiran = { pkgs, ... }: {
    xsession.windowManager.i3 = {
      config = {
        keybindings = lib.mkOptionDefault {
          "${config.i3_mod}+L" = "${lock_cmd}";
        };
      };
    };
    services.screen-locker = {
      enable = true;
      lockCmd = "${lock_cmd}";
    };
    xdg = {
      configFile."betterlockscreenrc".text = ''
        span_image=true
        lock_timeout=300
        fx_list=(dim blur dimblur pixel dimpixel color)
        dim_level=40
        blur_level=1
        pixel_scale=10,1000
        solid_color=333333
        wallpaper_cmd="${pkgs.feh}/bin/feh --bg-fill --no-xinerama $HOME/.background-image"
        quiet=false

        loginbox=${config.nord0}
        loginshadow=${config.nord0}
        locktext="The way is shut"
        font="sans-serif"
        ringcolor=${config.nord4}ff
        insidecolor=${config.nord1}00
        separatorcolor=${config.nord1}00
        ringvercolor=${config.nord4}ff
        insidevercolor=${config.nord1}00
        ringwrongcolor=${config.nord4}ff
        insidewrongcolor=${config.nord11}ff
        timecolor=${config.nord4}ff
        time_format="%H:%M:%S"
        greetercolor=${config.nord9}ff
        layoutcolor=${config.nord8}ff
        keyhlcolor=${config.nord11}ff
        bshlcolor=${config.nord11}ff
        verifcolor=${config.nord4}ff
        wrongcolor=${config.nord11}ff
        modifcolor=${config.nord11}ff
        bgcolor=${config.nord1}ff
      '';
    };
  };
}
