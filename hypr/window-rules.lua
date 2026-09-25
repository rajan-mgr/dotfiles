-- ~/.config/hypr/window-rules.lua

hl.window_rule({
	name = "kitty-float",
	match = { class = "^(kitty-float)$" },
	float = true,
	center = true,
	size = { 1200, 900 },
})

hl.layer_rule({
	name = "mako-blur",
	match = "mako",
	blur = true,
})

hl.window_rule({
	name = "kitty-no-blur",
	match = { class = "^(kitty|kitty-float)$" },
	no_blur = true,
})

-- No border when it's the only tiled window on the workspace;
-- border returns once a 2nd tiled window appears
hl.window_rule({
	name = "no-border-single-window",
	match = { float = false, workspace = "w[t1]" },
	border_size = 0,
})
