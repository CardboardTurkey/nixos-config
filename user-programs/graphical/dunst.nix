# Every section that isn't one of the above is interpreted as a rules to
# override settings for certain messages.
#
# Messages can be matched by
#    appname (discouraged, see desktop_entry)
#    body
#    category
#    desktop_entry
#    icon
#    match_transient
#    msg_urgency
#    stack_tag
#    summary
#
# and you can override the
#    background
#    foreground
#    format
#    frame_color
#    fullscreen
#    new_icon
#    set_stack_tag
#    set_transient
#    set_category
#    timeout
#    urgency
#    icon_position
#    skip_display
#    history_ignore
#    action_name
#    word_wrap
#    ellipsize
#    alignment
#    hide_text
#
# Shell-like globbing will get expanded.
#
# Instead of the appname filter, it's recommended to use the desktop_entry filter.
# GLib based applications export their desktop-entry name. In comparison to the appname,
# the desktop-entry won't get localized.
#
# SCRIPTING
# You can specify a script that gets run when the rule matches by
# setting the "script" option.
# The script will be called as follows:
#   script appname summary body icon urgency
# where urgency can be "LOW", "NORMAL" or "CRITICAL".
#
# NOTE: It might be helpful to run dunst -print in a terminal in order
# to find fitting options for rules.

# Disable the transient hint so that idle_threshold cannot be bypassed from the
# client
#[transient_disable]
#    match_transient = yes
#    set_transient = no
#
# Make the handling of transient notifications more strict by making them not
# be placed in history.
#[transient_history_ignore]
#    match_transient = yes
#    history_ignore = yes

# fullscreen values
# show: show the notifications, regardless if there is a fullscreen window opened
# delay: displays the new notification, if there is no fullscreen window active
#        If the notification is already drawn, it won't get undrawn.
# pushback: same as delay, but when switching into fullscreen, the notification will get
#           withdrawn from screen again and will get delayed like a new notification
#[fullscreen_delay_everything]
#    fullscreen = delay
#[fullscreen_show_critical]
#    msg_urgency = critical
#    fullscreen = show

#[espeak]
#    summary = "*"
#    script = dunst_espeak.sh

#[script-test]
#    summary = "*script*"
#    script = dunst_test.sh

#[ignore]
#    # This notification will not be displayed
#    summary = "foobar"
#    skip_display = true

#[history-ignore]
#    # This notification will not be saved in history
#    summary = "foobar"
#    history_ignore = yes

#[skip-display]
#    # This notification will not be displayed, but will be included in the history
#    summary = "foobar"
#    skip_display = yes

#[signed_on]
#    appname = Pidgin
#    summary = "*signed on*"
#    urgency = low
#
#[signed_off]
#    appname = Pidgin
#    summary = *signed off*
#    urgency = low
#
#[says]
#    appname = Pidgin
#    summary = *says*
#    urgency = critical
#
#[twitter]
#    appname = Pidgin
#    summary = *twitter.com*
#    urgency = normal
#
#[stack-volumes]
#    appname = "some_volume_notifiers"
#    set_stack_tag = "volume"
#
# vim: ft=cfg

{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "DejaVuSans Nerd Font 20px";
          follow = "keyboard";
          frame_width = 0;
          separator_color = "#${config.nord5}";
          width = "(0, 500)";
          min_icon_size = 70;
          max_icon_size = 80;
          corner_radius = 10;
          icon_path = "${pkgs.zafiro-icons}/share/icons/Zafiro-icons/places/48:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/actions:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/actions/16:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/actions/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/actions/48:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/actions/22-Dark:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/status:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/status/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/categories:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/categories/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/panel:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/panel/16-light:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/panel/16:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/panel/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/panel/22-light:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/emotes:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/mimetypes:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/mimetypes/48:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/emblems:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/emblems/16:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/previews:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/apps:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/apps/16:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/apps/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/apps/48:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/apps/scalable:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/devices:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/devices/22:
                       ${pkgs.zafiro-icons}/share/icons/Zafiro-icons/devices/48";
          progress_bar_height = 30;
          idle_threshold = 5;
        };
        urgency_low = {
          background = "#${config.nord0}";
          foreground = "#${config.nord5}";
          timeout = 10;
        };
        urgency_normal = {
          background = "#${config.nord3}";
          foreground = "#${config.nord5}";
          timeout = 10;
        };
        urgency_critical = {
          background = "#${config.nord11}";
          foreground = "#${config.nord6}";
          timeout = 0;
        };
      };
    };
  };
}