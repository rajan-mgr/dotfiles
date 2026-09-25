------------------
---- MONITOR -----
------------------
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.monitor({
    output = "",          -- Empty string acts as the wildcard fallback
    mode = "preferred",   -- Automatically selects native resolution
    position = "auto",    -- Automatically places it next to your laptop screen
    scale = 1,
})

------------------
---- ENV VARS ----
------------------
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

------------------
---- PROGRAMS ----
------------------
local terminal      = "kitty"
local fileManager    = "thunar"
local menu           = "rofi -show drun"
local browser        = "helium-browser"
local terminalFloat  = "kitty --class kitty-float"

------------------
---- AUTOSTART ---
------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("flameshot")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("openrgb")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("/usr/lib/gnome-settings-daemon/gsd-xsettings")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(
        'sh -c \'sleep 1; f="$HOME/.cache/hyprquickpaper/current_wallpaper"; [ -f "$f" ] && awww img "$(cat "$f")"\''
    )
end)

------------------
---- GENERAL -----
------------------
hl.config({
    general = {
        gaps_in         = 0,
        gaps_out        = 0,
        border_size     = 1,
        col = {
            active_border   = "#6b5a75",
            inactive_border = "rgba(393552ff)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "master",
    },

    decoration = {
        rounding       = 0,
        rounding_power = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 7,
            render_power = 6,
            color        = "rgba(00000099)",
        },
        blur = {
            enabled            = true,
            size               = 8,
            passes             = 2,
            new_optimizations  = true,
            vibrancy           = 1,
        },
    },

    animations = {
        enabled = false,
    },
})

------------------
---- ANIMATIONS --
------------------
hl.curve("quick",  { type = "bezier", points = { { 0.2, 0 },   { 0.1, 1 } } })
hl.curve("snap",   { type = "bezier", points = { { 0.3, 1 },   { 0.4, 1 } } })
hl.curve("bounce", { type = "bezier", points = { { 0.4, 1.2 }, { 0.6, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 6,    bezier = "quick" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4,    bezier = "bounce" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 3.5,  bezier = "bounce" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 4,    bezier = "bounce" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 0.25, bezier = "quick" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 0.2,  bezier = "quick" })
hl.animation({ leaf = "fade",          enabled = true, speed = 0.6,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 2.8,  bezier = "snap" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 2.5,  bezier = "snap",   style = "slide" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2.5,  bezier = "snap",   style = "slide" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.18, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.15, bezier = "quick" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4,    bezier = "bounce", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 4,    bezier = "bounce", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3,    bezier = "quick",  style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 6,    bezier = "quick" })

------------------
---- LAYOUTS -----
------------------
hl.config({
    master = {
        new_status  = "slave",
        orientation = "left",
        mfact       = 0.5,
    },
})

------------------
---- MISC --------
------------------
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

------------------
---- INPUT -------
------------------
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Horizontal 3-finger swipe: switch workspace left/right
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Vertical 3-finger swipe: toggle the special/scratchpad workspace
hl.gesture({
    fingers   = 3,
    direction = "vertical",
    action    = function()
        hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    end,
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + Return",        hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W",             hl.dsp.window.close())
hl.bind(mainMod .. " + E",             hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",             hl.dsp.window.pseudo())
hl.bind("SUPER + O",                   hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + B",                   hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminalFloat))

-- wallpaper
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("qs -c hyprquickpaper"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("Print", hl.dsp.exec_cmd("flameshot gui"))

------------------------------
---- WINDOW SWITCHING / SWAP -
------------------------------
-- Cycle focus through open windows
hl.bind(mainMod .. " + J", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + K", hl.dsp.window.cycle_next({ next = false }))

-- Swap the active window's position with the next/prev one in the layout
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ next = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }))

------------------------------
---- RESIZE WINDOWS (keys) ---
------------------------------
local resizeStep = 40
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = resizeStep,  y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = resizeStep,  relative = true }), { repeating = true })

----------------------------------------
---- STACK ORIENTATION (master layout) -
----------------------------------------
-- Cycles the master stack between vertical/horizontal split arrangements
hl.bind(mainMod .. " + CTRL + Space", hl.dsp.layout("orientationcycle"))

------------------
---- MEDIA KEYS --
------------------
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower --device smc::kbd_backlight"))
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise --device smc::kbd_backlight"))
hl.bind("ALT + bracketright",    hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("ALT + bracketleft",     hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("ALT + z",               hl.dsp.exec_cmd("flameshot gui"))

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("swayosd-client --brightness raise"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

------------------
---- FULLSCREEN --
------------------
-- Toggle maximized fullscreen (takes up workspace space, keeps waybar visible)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Toggle true fullscreen (takes up the entire physical screen)
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

------------------
---- LOCK --------
------------------
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.local/bin/lock.sh"))

-- source
dofile(os.getenv("HOME") .. "/.config/hypr/window-rules.lua")
