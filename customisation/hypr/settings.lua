local vars = require("variables")
local scheme = require("scheme.current")

hl.device({
    name = "asue140d:00-04f3:31b9-touchpad",
    accel_profile = "adaptive",
    sensitivity = 0.0,
})

hl.device({
    name = "elan9008:00-04f3:2f2c",
    enabled = false,
})

hl.config({
    general = {
        layout = "dwindle",
        border_size = vars.windowBorderSize,
        gaps_in = vars.windowGapsIn,
        gaps_out = vars.windowGapsOut,
        gaps_workspaces = vars.workspaceGaps,
        col = {
            active_border = vars.activeWindowBorderColour,
            inactive_border = vars.inactiveWindowBorderColour,
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
        key_press_enables_dpms = true,

        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        allow_session_lock_restore = true,
        session_lock_xray = true,
        force_default_wallpaper = 0,
        on_focus_under_fullscreen = 2,
        background_color = "rgb(" .. scheme.surfaceContainer .. ")",
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
        rounding = vars.windowRounding,

        blur = {
            enabled           = vars.blurEnabled,
            xray              = vars.blurXray,
            special           = vars.blurSpecialWs,
            ignore_opacity    = true, -- Allows opacity blurring
            new_optimizations = true,
            popups            = vars.blurPopups,
            input_methods     = vars.blurInputMethods,
            size              = vars.blurSize,
            passes            = vars.blurPasses,
        },

        shadow = {
            enabled      = vars.shadowEnabled,
            range        = vars.shadowRange,
            render_power = vars.shadowRenderPower,
            color        = vars.shadowColour,
        },
    },
})
