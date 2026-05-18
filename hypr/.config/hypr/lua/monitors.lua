-- =========================================================================
-- =========================================================================
-- MULTI-MONITOR SETUP
-- =========================================================================

-- Primary Laptop Display
hl.monitor({
    output = "desc:California Institute of Technology 0x1410",
    mode = "3072x1920@60.00Hz",
    position = "0x0",
    scale = 2.0
})

-- Samsung Odyssey G60SD
hl.monitor({
    output = "desc:Samsung Electric Company Odyssey G60SD HNAX802421",
    mode = "2560x1440@120.00Hz",
    position = "-2560x0",
    scale = 1.0
})

-- Lenovo Auxiliary Display
hl.monitor({
    output = "desc:Lenovo Group Limited LEN LT1913pA V3000RRP",
    mode = "1280x1024@60Hz",
    position = "-3840x0",
    scale = 1.0
})
