from libqtile import layout, hook
from libqtile.config import Group, Key, Match, Screen
from libqtile.lazy import lazy

import os
import subprocess

@hook.subscribe.startup_once
def autostart():
  cmds = [
    ["dbus-update-activation-environment", "--all"],
    ["xrdb", os.path.expanduser("~/env/session.x11/xresources")],
    ["xsetroot", "-solid" "#000000"],
    ["i3lock"],
    ["autorandr", "-c"],
    [os.path.expanduser("~/env/service/init")],
  ]
  for cmd in cmds:
    subprocess.Popen(cmd)

groups = [
  Group("1"),
  Group("2"),
  Group("3", matches=[Match(wm_class="nvim")]),
  Group("4"),
  Group("5", matches=[Match(wm_class="terminal")]),
]

def move_to_group(qtile, mov):
  i = qtile.groups.index(qtile.current_group)
  qtile.current_window.togroup(groups[i+mov].name, switch_group=True)

super = "mod4"
keys = [
  Key(["control", super], "r", lazy.reload_config()),
  Key(["control", super], "c", lazy.window.kill()),
  Key(["control", super], "left", lazy.function(move_to_group, -1)),
  Key(["control", super], "right", lazy.function(move_to_group, +1)),
  Key([], "F12", lazy.group["5"].toscreen()),
]

for i in groups:
  keys.append(Key(["control", super], i.name, lazy.group[i.name].toscreen()))

for mkey in ["XF86AudioRaiseVolume", "XF86AudioLowerVolume","XF86AudioMute", "XF86AudioPlay", "XF86MonBrightnessDown","XF86MonBrightnessUp"]:
  keys.append(Key([], mkey, lazy.spawn(f"keyrun {mkey}")))

for skey in "tlpvsxm":
  keys.append(Key([super], skey, lazy.spawn(f"keyrun super+{skey}")))

for vt in range(1,4):
  keys.append(Key(["control", "mod1"], f"f{vt}", lazy.core.change_vt(vt)))

layouts = [layout.Columns(border_width=1)]
floating_layout = layout.Floating(float_rules=[*layout.Floating.default_float_rules])
screens = [Screen()]

follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
focus_on_window_activation = "smart"

