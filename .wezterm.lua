local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "kanagawabones"
config.enable_tab_bar = false
config.font = wezterm.font("DankMono Nerd Font", { weight = "Bold" })
config.font_size = 18
config.initial_cols = 100
config.initial_rows = 30
config.keys = {
	{ key = "c", mods = "SUPER|SHIFT|CTRL|META", action = wezterm.action.ActivateCopyMode },
}
config.line_height = 1.2
config.macos_window_background_blur = 60
config.window_background_opacity = 0.9
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = { bottom = 0, left = 12, right = 12, top = 12 }

return config
