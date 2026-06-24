hl.device({
    name = "asue140d:00-04f3:31b9-touchpad",
    accel_profile = "adaptive",
    sensitivity = 0.0,
})

hl.device({
    name = "elan9008:00-04f3:2f2c",
    enabled = false,
})

hl.env("EDITOR", "nano")

hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 5,
    bezier = "emphasizedDecel",
    style = "slide",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 4,
    bezier = "emphasizedAccel",
    style = "slide",
})
hl.animation({
    leaf = "fadeLayers",
    enabled = true,
    speed = 5,
    bezier = "standard",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 5,
    bezier = "emphasizedDecel",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "emphasizedAccel",
})
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 6,
    bezier = "standard",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 5,
    bezier = "standard",
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 4,
    bezier = "specialWorkSwitch",
    style = "slidefadevert 15%",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 6,
    bezier = "standard",
})
hl.animation({
    leaf = "fadeDim",
    enabled = true,
    speed = 6,
    bezier = "standard",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 6,
    bezier = "standard",
})
hl.config({
    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.8,
        smart_split = true,
    },
    master = {
        new_status = "master",
        new_on_top = 1,
        mfact = 0.5,
    },
    general = {
        resize_on_border = true,
        layout = "dwindle",
        border_size = 2,
        gaps_in = 2,
        gaps_out = 4,
        col = {
            active_border = { colors = { "rgba(f2afadaa)", "rgba(80556aaa)" }, angle = 45 },
        },
    },
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        sensitivity = 0, -- mouse sensitivity
        accel_profile = "flat", -- flat or adaptive or blank or EMPTY means libinput’s default mode
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = true,
        mouse_refocus = false,
        float_switch_override_focus = false,
        touchdevice = {
            enabled = false,
        },
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            tap_to_click = true,
            drag_lock = false,
        },
        -- below for devices with touchdevice ie. touchscreen
        -- below is for table see link above for proper variables
        tablet = {
            transform = 0,
            left_handed = 0,
        },
    },
    gestures = {
        workspace_swipe_distance = 500,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
        --workspace_swipe_use_r = true #uncomment if wanted a forever create a new workspace with swipe right
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
        mouse_move_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    --Could help when scaling and not pixelating
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
    render = {
        direct_scanout = 0,
    },
    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 2, -- change to 1 if want to disable
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
        inactive_timeout = 3,
    },
    decoration = {
        rounding = 20,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.3,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
            popups = true,
        },
    },
    animations = {
        enabled = true,
        -- Animation curves
        -- Animation configs
    },
})
