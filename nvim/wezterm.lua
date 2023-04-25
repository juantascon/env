local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

config.font = wezterm.font "JetBrains Mono"
config.font_size = 16.0
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
config.enable_tab_bar = false
config.disable_default_key_bindings = true

config.keys = {
  {key = 'Insert', mods = 'SHIFT', action = act.PasteFrom("PrimarySelection")},
  {key = '=', mods = 'CTRL', action = act.IncreaseFontSize},
  {key = '-', mods = 'CTRL', action = act.DecreaseFontSize},
  {key = '0', mods = 'CTRL', action = act.ResetFontSize},
}

return config
