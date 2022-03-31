{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
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

        loginbox=2e3440ff
        # loginshadow=3b425200
        locktext="The way is shut"
        font="sans-serif"
        ringcolor=d8dee9ff
        insidecolor=3b425200
        separatorcolor=3b425200
        ringvercolor=d8dee9ff
        insidevercolor=3b425200
        ringwrongcolor=d8dee9ff
        insidewrongcolor=bf616aff
        timecolor=d8dee9ff
        time_format="%H:%M:%S"
        greetercolor=81a1c1ff
        layoutcolor=88c0d0ff
        keyhlcolor=bf616aff
        bshlcolor=bf616aff
        verifcolor=d8dee9ff
        wrongcolor=bf616aff
        modifcolor=bf616aff
        bgcolor=3b4252ff
      '';
    };
    services.betterlockscreen ={
      enable = true;
      arguments = [ "blur" ];
    };
    services.screen-locker = {
      enable = true;
    };
  };
}