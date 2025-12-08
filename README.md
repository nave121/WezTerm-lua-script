# WezTerm Synthwave Deck
Turbocharge WezTerm with a glassy synthwave skin, crisp Meslo/JetBrains fonts, and fast-access keybindings. This repo is a single, dialed-in `.wezterm.lua` you can drop into your setup or riff on to make your terminal glow.

## Quick Start
- Install WezTerm (latest recommended).
- Clone or copy `.wezterm.lua` into your config location, or run directly:
  - `wezterm start --config-file ./.wezterm.lua`
- Verify fonts: `wezterm ls-fonts --list-system | grep MesloLGS` (JetBrains Mono is the fallback).
- Check version for bug reports: `wezterm --version`.

## Highlights
- Synthwave gradient background with light glass blur and dimmed inactive panes.
- Custom ANSI palette with neon lime “yellow” for legible prompts.
- Integrated tab bar at the bottom, max width 40, with bold active tab contrast.
- Right status bar shows hostname, time, and battery with color separators.
- Toggleable opacity and a tight keybinding set for pane navigation.

## Keybindings (defaults in this config)
- `ALT+Enter` fullscreen toggle
- `ALT+q` quit WezTerm
- `CTRL+SHIFT+B` toggle opacity (`toggle-opacity` event)
- `ALT+h/j/k/l` move across panes

## Customize Fast
- Colors: edit the `colors` table; keep hex strings and order gradients top→bottom.
- Fonts: adjust `font_with_fallback` families or `font_size` to match your DPI.
- Tabs/status: tweak `tab_bar` or `update-status` event to add/remove segments.
- Window feel: change `window_background_opacity`, `text_background_opacity`, or `macos_window_background_blur` to taste.

## Development Notes
- Structure is bannered by comments: font/general, background/glass, colors/cursor/tabs, status bar, keybindings/toggles.
- Lua style: 2-space indent, locals by default, trailing commas in tables.
- Event safety: `update-status` and `toggle-opacity` run hot; keep changes small and nil-check optional fields (like `cwd_uri`).
- Validate manually: start WezTerm with this config, open a few panes, and confirm status bar, cursor, and tab visuals look right.

## Troubleshooting
- Fonts missing? Swap to any Nerd Font in `font_with_fallback`.
- Colors look flat? Ensure GPU acceleration is on in WezTerm preferences.
- Status bar misaligned? Check terminal width or reduce tab width via `tab_max_width`.
