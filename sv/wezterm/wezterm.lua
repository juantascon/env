local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

config.font = wezterm.font "JetBrains Mono"
config.font_size = 14.0
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
config.use_fancy_tab_bar = false

config.keys = {
  {key = "1", mods = "CTRL", action = act.ActivateTab(0)},
  {key = "2", mods = "CTRL", action = act.ActivateTab(1)},
  {key = "3", mods = "CTRL", action = act.ActivateTab(2)},
  {key = "4", mods = "CTRL", action = act.ActivateTab(3)},
  {key = "5", mods = "CTRL", action = act.ActivateTab(4)},

  {key = "w", mods = "CTRL", action = act.CloseCurrentTab({confirm=true})},
  {key = "t", mods = "CTRL", action = act.SpawnCommandInNewTab({domain="CurrentPaneDomain", cwd=wezterm.home_dir})},
  {key = "j", mods = "CTRL", action = act.ActivateTabRelative(1)},
  {key = "k", mods = "CTRL", action = act.ActivateTabRelative(-1)},
  {key = "j", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1)},
  {key = "k", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1)},

  {key = "h", mods = "CTRL", action = act.ActivateCopyMode},
  {key = "g", mods = "CTRL", action = act.ShowDebugOverlay},
  {key = "P", mods = "CTRL", action = act.ActivateCommandPalette},

  {key = "y", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection")},
  {key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection")},

  {key = "=", mods = "CTRL", action = act.IncreaseFontSize},
  {key = "-", mods = "CTRL", action = act.DecreaseFontSize},
  {key = "0", mods = "CTRL", action = act.ResetFontSize},
  {key = "l", mods = "CTRL", action = act.ResetTerminal},
}

return config
