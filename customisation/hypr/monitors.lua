hl.monitor({
    output = "eDP-1",
    disabled = false,
    mode = "2880x1800@60.0",
    position = "0x0",
    scale = "1.5",
})

hl.monitor({ output = "HDMI-A-2", mode = "3440x1440@100", position = "1920x-500", scale = "auto", vrr=0  })
hl.monitor({ output = "", mode = "preferred", position = "auto-right", scale = "2"  })
