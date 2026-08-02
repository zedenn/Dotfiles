-- =========================================================================
-- ENVIRONMENT VARIABLES
-- =========================================================================
-- Using hl.env("KEY", "VALUE")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rosepine")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto") -- Wayland for electron apps

-- =========================================================================
-- DEFAULT APPLICATIONS
-- =========================================================================
_G.mainMod = "SUPER"
_G.terminal = "foot"
_G.fileManager = "thunar"
_G.menu = "wofi -i --show drun"
-- =========================================================================
-- SOURCING
-- =========================================================================

require("lua.keybinds")
require("lua.monitors")
require("lua.windowrules")
require("lua.monitorstate")

-- =========================================================================
-- MONITORS
-- =========================================================================
hl.config({
    monitor = {
        ", preferred, auto, 1"
    }
})

-- =========================================================================
-- LID SWITCH BINDINGS
-- =========================================================================
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/clamshell_lua.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/clamshell_lua.sh"), { locked = true })

-- =========================================================================
-- AUTOSTART (Startup Programs)
-- =========================================================================
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("~/.config/hypr/scripts/clamshell_lua.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper -c ~/.config/hypr/config/hyprpaper.conf")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Scratchpads
    hl.exec_cmd("env HYPR_STARTUP=magic " .. terminal .. " --app-id 'magic-terminal'")
    hl.exec_cmd("env HYPR_STARTUP=music " .. terminal .. " --app-id 'special-cmus' -e cmus")
end)

hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)

-- =========================================================================
-- WINDOW RULES (Magic Terminal & Cmus)
-- =========================================================================
-- Static effects like float, size, and center now expect strict explicit values

hl.window_rule({
    match = { class = "magic-terminal" },
    float = true,
    size = { "(monitor_w*0.6)", "(monitor_h*0.5)" },
    center = true
})

hl.window_rule({
    match = { class = "special-cmus" },
    float = true,
    size = { "(monitor_w*0.6)", "(monitor_h*0.5)" },
    center = true
})
-- =========================================================================
-- LOOK AND FEEL
-- =========================================================================
-- =========================================================================
-- 1. BEZIER CURVES & ANIMATIONS
-- =========================================================================
hl.curve("myBezier", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } }
})

hl.curve("mySpring", {
    type = "spring",
    mass = 1,
    stiffness = 70,
    dampening = 10
})

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

-- =========================================================================
-- 2. GENERAL WINDOW LAYOUT
-- =========================================================================
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 3,
        border_size = 2,
        resize_on_border = false,
        layout = "dwindle",

        col = {
            active_border = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)"
        }
    }
})

-- =========================================================================
-- 3. WINDOW DECORATIONS (Blur & Shadows)
-- =========================================================================
hl.config({
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true
        },

        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        }
    }
})

hl.config({
    dwindle = {
        preserve_split = true
    },

    master = {
        new_status = "master"
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true
    }
})

-- =========================================================================
-- INPUT & GESTURES
-- =========================================================================
hl.config({
    input = {
        kb_layout = "fi",
        kb_options = "caps:swapescape",

        follow_mouse = 1,
        accel_profile = "flat",
        force_no_accel = true,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false
        }
    },

    -- Note the change from general/input section style:
    -- Gestures are an array list in the new Lua API
    gesture = {
        "3, horizontal, workspace"
    }
})

-- =========================================================================
-- GLOBAL SYSTEM RULES
-- =========================================================================
-- Standard window and layer rules use explicit target tables

hl.window_rule({
    match = { class = ".*" },
    suppress_event = "maximize"
})

hl.layer_rule({
    match = { namespace = "^(wofi)$" },
    no_anim = true
})

-- =========================================================================
-- TEARING TOGGLE (Appends to your existing general block)
-- =========================================================================
hl.config({
    general = {
        allow_tearing = false
    }
})
