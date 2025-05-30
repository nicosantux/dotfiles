local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback({
	{ family = "DankMono Nerd Font", weight = "Bold" },
	{ family = "SF Pro", weight = "DemiBold" },
})
config.font_size = 16
config.initial_cols = 100
config.initial_rows = 30
config.keys = {
	{ key = "c", mods = "SUPER|SHIFT|CTRL|META", action = wezterm.action.ActivateCopyMode },
}
config.line_height = 1.2
config.macos_window_background_blur = 20
config.window_background_opacity = 0.85
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.max_fps = 240
config.window_padding = { bottom = 0, left = 12, right = 12, top = 12 }

return config
