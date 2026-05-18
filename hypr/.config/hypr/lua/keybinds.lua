-- =========================================================================
-- CUSTOM & APPLICATION KEYBINDS
-- =========================================================================
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock --config ~/.config/hypr/config/hyprlock.conf"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" -t png - | wl-copy -t image/png'))
hl.bind("CONTROL + 7", hl.dsp.exec_cmd("wtype -M ctrl -k slash"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.center())
end)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- =========================================================================
-- DIRECTIONAL FOCUS
-- =========================================================================
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- =========================================================================
-- SPECIAL WORKSPACES & NAVIGATION
-- =========================================================================
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + F", hl.dsp.workspace.toggle_special("music"))

hl.bind(mainMod .. " + CONTROL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CONTROL + left", hl.dsp.focus({ workspace = "e-1" }))

-- =========================================================================
-- MOUSE WINDOW DRAGGING & RESIZING
-- =========================================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { type = "mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { type = "mouse" })

-- =========================================================================
-- NUMBERED WORKSPACE NAVIGATION (Super + 1-0)
-- =========================================================================
for i = 1, 10 do
    -- Convert index 10 to key "0"
    local key = tostring(i % 10)

    -- Bind Super + Number to switch to that workspace
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }))

    -- Bind Super + Shift + Number to move active window to that workspace
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end
