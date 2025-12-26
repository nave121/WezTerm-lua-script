local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()
config:set_strict_mode(true)

-- ============================================================
--  FONT / GENERAL
-- ============================================================
config.color_scheme = 'synthwave-everything'

config.font = wezterm.font_with_fallback({
  { family = 'MesloLGS NF',    weight = 'Regular' },
  { family = 'JetBrains Mono', weight = 'Regular' },
})
config.font_size = 16

local TITLEBAR_COLOR = '#120820' -- deep synthwave purple

config.native_macos_fullscreen_mode = true
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_frame = {
  font = wezterm.font { family = 'MesloLGS NF', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = TITLEBAR_COLOR,
  inactive_titlebar_bg = TITLEBAR_COLOR,
}

config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 40

config.window_padding = {
  -- keep prompt/text clear of the integrated macOS traffic lights
  left   = 6,
  right  = 6,
  top    = 30,
  bottom = 6,
}

-- ============================================================
--  BACKGROUND / GLASS
-- ============================================================
-- Solid text cells, slight glass overall if you want to tween later
config.window_background_opacity = 0.9
config.text_background_opacity   = 0.98
config.macos_window_background_blur = 10

-- Clean synthwave gradient, with the nice orange back
config.window_background_gradient = {
  orientation = 'Vertical',
  colors = {
    '#050014', -- deep violet
    '#2b0b3f', -- purple
    '#61105e', -- magenta
    '#9b197a', -- hot pink
    '#ff4b81', -- bright pink
    '#ffc46b', -- sunset orange bottom
  },
  interpolation = 'Linear',
  blend = 'Rgb',
  noise = 10,
}

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.35,
}

-- ============================================================
--  COLORS / CURSOR / TABS (with custom ANSI yellow)
-- ============================================================
config.cursor_thickness = 2
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 700

config.colors = {
  foreground = '#f9f7ff',
  background = '#050014',

  cursor_bg = '#ffcc70',
  cursor_fg = '#050014',
  cursor_border = '#ffcc70',

  selection_fg = 'none',
  selection_bg = '#3b0f4a',

  scrollbar_thumb = '#3b0f4a',
  split = '#ff007c',

  -- override ANSI palette so "yellow" (used by your prompt)
  -- is neon lime instead of washed-out yellow
  ansi = {
    '#050014', -- black
    '#ff5c57', -- red
    '#5af78e', -- green
    '#c5ff00', -- YELLOW -> neon lime (key change)
    '#57c7ff', -- blue
    '#ff6ac1', -- magenta
    '#9aedfe', -- cyan
    '#f1f1f0', -- white
  },
  brights = {
    '#686868', -- bright black
    '#ff5c57', -- bright red
    '#5af78e', -- bright green
    '#d9ff4a', -- bright yellow/lime
    '#57c7ff', -- bright blue
    '#ff6ac1', -- bright magenta
    '#9aedfe', -- bright cyan
    '#ffffff', -- bright white
  },

  tab_bar = {
    background = '#02000b',
    active_tab = {
      bg_color = '#ff007c',
      fg_color = '#02000b',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#f1e9ff',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = '#321a4a',
      fg_color = '#ffffff',
      italic = true,
    },
    new_tab = {
      bg_color = '#02000b',
      fg_color = '#ffcc70',
    },
    new_tab_hover = {
      bg_color = '#ffcc70',
      fg_color = '#02000b',
      italic = true,
    },
  },
}

-- ============================================================
--  RIGHT STATUS BAR (hostname • time • battery)
-- ============================================================
wezterm.on('update-status', function(window, pane)
  local cells = {}

  local hostname = wezterm.hostname()
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri and cwd_uri.host then
    hostname = cwd_uri.host
  end
  table.insert(cells, ' ' .. hostname)

  local date = wezterm.strftime(' %a %b %-d %H:%M')
  table.insert(cells, date)

  local batt_icons = { '', '', '', '', '' }
  for _, b in ipairs(wezterm.battery_info()) do
    local icon = batt_icons[math.ceil(b.state_of_charge * #batt_icons)]
    table.insert(cells, string.format('%s %.0f%%', icon, b.state_of_charge * 100))
  end

  local text_fg = '#e5e1ff'
  local colors = {
    TITLEBAR_COLOR,
    '#3b0f4a',
    '#ff007c',
    '#ff4b81',
    '#ffc46b',
    '#16e0ff',
  }

  local elements = {}
  while #cells > 0 and #colors > 1 do
    local text = table.remove(cells, 1)
    local prev = table.remove(colors, 1)
    local curr = colors[1]

    table.insert(elements, { Background = { Color = prev } })
    table.insert(elements, { Foreground = { Color = curr } })
    table.insert(elements, { Text = '' })
    table.insert(elements, { Background = { Color = curr } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end)

-- ============================================================
--  KEYBINDINGS & TOGGLES
-- ============================================================
config.keys = {
  { key = 'Enter', mods = 'ALT',        action = act.ToggleFullScreen },
  { key = 'q',     mods = 'ALT',        action = act.QuitApplication },

  { key = 'o',     mods = 'ALT',        action = act.EmitEvent 'toggle-opacity' },
  { key = 's',     mods = 'ALT',        action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'd',     mods = 'ALT',        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 't',     mods = 'ALT',        action = act.SpawnTab 'DefaultDomain' },
  { key = 'w',     mods = 'ALT',        action = act.CloseCurrentPane { confirm = true } },
  { key = '=',     mods = 'ALT',        action = act.IncreaseFontSize },
  { key = '-',     mods = 'ALT',        action = act.DecreaseFontSize },
  { key = '[',     mods = 'ALT',        action = act.ActivateTabRelative(-1) },
  { key = ']',     mods = 'ALT',        action = act.ActivateTabRelative(1) },

  { key = 'h', mods = 'ALT',            action = act.ActivatePaneDirection 'Left'  },
  { key = 'l', mods = 'ALT',            action = act.ActivatePaneDirection 'Right' },
  { key = 'j', mods = 'ALT',            action = act.ActivatePaneDirection 'Down'  },
  { key = 'k', mods = 'ALT',            action = act.ActivatePaneDirection 'Up'    },
}

wezterm.on('toggle-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  local current = overrides.window_background_opacity or config.window_background_opacity

  if current >= 1.0 then
    overrides.window_background_opacity = 0.90
  else
    overrides.window_background_opacity = 1.0
  end

  window:set_config_overrides(overrides)
end)

config.audible_bell = 'Disabled'

return config
