local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Apparence
config.color_scheme = "Rosé Pine (base16)"
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font Mono", weight = "Medium" },
})
config.font_size = 10.0
config.line_height = 0.95
config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}
config.initial_cols = 150
config.initial_rows = 45

-- Comportement
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.default_cursor_style = "SteadyBar"
config.audible_bell = "Disabled"

-- Tabs
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Raccourcis
config.keys = {
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
}

return config
