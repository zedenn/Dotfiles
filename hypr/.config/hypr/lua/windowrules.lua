-- =========================================================================
-- IMV FLOATING CONFIGURATION
-- =========================================================================
hl.window_rule({
    match = { class = "^(imv)$" },
    float = true,
    size = { "monitor_w * 0.9", "monitor_h * 0.9" },
    center = true
})

-- =========================================================================
-- NO-GAPS / NO-BORDERS FOR SINGLE TILED WINDOWS
-- =========================================================================
hl.workspace_rule({
    workspace = "w[t1]",
    gaps_out = 0,
    gaps_in = 0
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_out = 0,
    gaps_in = 0
})

hl.window_rule({
    match = { float = false, workspace = "w[t1]" },
    border_size = 0,
    rounding = 0
})

hl.window_rule({
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding = 0
})

-- =========================================================================
-- THUNAR DIALOGS & POPUPS
-- =========================================================================
hl.window_rule({
    match = { class = "^(thunar)$", title = "^(Rename).*$" },
    float = true,
    center = true
})

hl.window_rule({
    match = { class = "^(thunar)$", title = "^(File Operation Progress).*$" },
    float = true,
    center = true
})

-- =========================================================================
-- XWAYLAND VISUAL INDICATOR
-- =========================================================================
hl.window_rule({
    match = { xwayland = true },
    border_color = "rgba(ff0066ee)"
})

-- =========================================================================
-- STARTUP SPECIAL WORKSPACE MATCHING RULES
-- =========================================================================
hl.window_rule({
    match = { class = "^magic-terminal$" },
    workspace = "special:magic silent"
})

hl.window_rule({
    match = { class = "^special-cmus$" },
    workspace = "special:music silent"
})
