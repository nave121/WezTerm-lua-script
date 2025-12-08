# Repository Guidelines
This repository contains a single, opinionated WezTerm configuration. Keep changes small, validated in a running terminal window, and consistent with the existing synthwave aesthetic.

## Project Structure & Module Organization
- `.wezterm.lua` is the entry point. Sections are grouped by comment banners: font/general, background/glass, colors/cursor/tabs, status bar, and keybindings/toggles.
- Event hooks power dynamic pieces: `update-status` renders hostname/time/battery, and `toggle-opacity` manages the glass effect. Touch these carefully to avoid runtime errors.
- If the config grows, place shared helpers in `lua/` modules and `require` them from `.wezterm.lua` to keep the top-level file readable.

## Build, Test, and Development Commands
- `wezterm start --config-file ./.wezterm.lua` — launch a window using this config; close the window to stop the session.
- `wezterm ls-fonts --list-system | grep "MesloLGS"` — verify the primary fallback fonts exist before tweaking font stacks.
- `wezterm --version` — confirm the WezTerm build you are targeting when reporting or debugging behavior changes.

## Coding Style & Naming Conventions
- Lua style: 2-space indentation, locals by default, and trailing commas in tables to reduce diff noise.
- Constants (e.g., `TITLEBAR_COLOR`) stay uppercase snake case; actions use the `act` alias for clarity.
- Keep related settings together under the existing banners; prefer small helper functions over long inline blocks when adding new event logic.
- Use hex strings for colors and keep gradient arrays ordered top-to-bottom.

## Testing Guidelines
- Manual validation is expected: run with the command above, open a few panes, and confirm the status bar, cursor behavior, and tab colors render correctly.
- Toggle opacity with `ALT+B` (defined as `toggle-opacity`) to ensure overrides still work.
- When altering keybindings, verify no collisions with WezTerm defaults you rely on.

## Commit & Pull Request Guidelines
- Commit messages: concise, present-tense, imperative (e.g., `Adjust tab bar contrast`).
- PRs should describe the visual/behavioral change, list manual checks performed, and include screenshots for color or layout tweaks.
- Reference related issues and note the WezTerm version used for testing to aid reproducibility.
