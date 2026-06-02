# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal `~/.config` dotfiles for a macOS desktop. The interesting configs are an interlocking trio — **AeroSpace** (tiling WM), **SketchyBar** (status bar), and **Hammerspoon** (Lua scripting / hyper key) — that communicate via SketchyBar events. Other top-level dirs (`nvim/`, `ghostty/`, `nushell/`, `starship.toml`, `karabiner/`, `yazi/`, etc.) are standalone tool configs.

`.gitignore` excludes credential-bearing dirs (`gcloud`, `raycast`, `github-copilot`, `calibre`, etc.). Don't add them back.

## Reload commands

After editing any of the WM/bar/scripting configs, reload via:

- **Hammerspoon + SketchyBar + AeroSpace together:** press Hyper+R (see below). Equivalent to `hs -c 'hs.reload()'` — `hammerspoon/init.lua` chains `bar.reload()` and `aerospace reload-config`.
- **SketchyBar only:** `brew services restart sketchybar` (this is what `modules/sketchybar.lua:reload()` runs).
- **AeroSpace only:** `aerospace reload-config`.
- **Neovim plugins:** `:Lazy sync` inside nvim.

## Hyper key — central to all hotkeys

The hyper modifier is `ctrl+alt+cmd+shift`. Three independent paths can produce it:

1. **Laptop fn key** — `karabiner.json` remaps fn → `cmd+ctrl+option+shift` (tap-fn = Escape).
2. **Ducky right alt** — `karabiner.json` has a `device_if`-scoped rule mapping right_option → hyper on the Ducky only (VID `0x3233`, tap-right-alt = Escape).
3. **Physical F19** — `hammerspoon/modules/hyper.lua` installs an `eventtap` that intercepts F19 and re-emits subsequent keydowns with hyper flags. Requires hardware that emits F19 (custom firmware / macropad); karabiner does not produce it.

`karabiner.json` also remaps caps_lock → left_control (held) / Escape (tap). This is independent of the hyper paths above.

All Hammerspoon hotkeys bind against `util.hyper = { "ctrl", "alt", "cmd", "shift" }` (`hammerspoon/util.lua`). New global hotkeys go in a `hammerspoon/modules/*.lua` exposing `init()`, then required + invoked from `hammerspoon/init.lua` — no raw bindings in `init.lua` itself.

A 50ms release grace timer in `hyper.lua` exists so combos like F19→R don't lose the R keydown if F19 lifts first — don't remove it.

## AeroSpace ↔ SketchyBar event bridge

The two communicate exclusively through SketchyBar custom events:

1. `aerospace/aerospace.toml` declares `exec-on-workspace-change` → `sketchybar --trigger aerospace_workspace_change …` with `FOCUSED_WORKSPACE` / `PREV_WORKSPACE` env vars.
2. Nearly every workspace-affecting binding in `aerospace.toml` appends `exec-and-forget sketchybar --trigger change-workspace-monitor`. When adding a new workspace/move binding, **include this trigger** or the bar won't update.
3. `hammerspoon/modules/sketchybar.lua` also fires `change-workspace-monitor` on `hs.screen.watcher` events (monitor plug/unplug).
4. `sketchybar/items/space_windows.sh` subscribes spaces to `aerospace_workspace_change`; the handler in `sketchybar/plugins/aerospace.sh` calls `update_apps` (defined in `sketchybar/aerospace.sh`) which queries `aerospace list-windows` and rewrites each space's icon strip via `sketchybar/plugins/icon_map.sh`.

SketchyBar layout: `sketchybarrc` is the entry point; `items/*.sh` define bar segments (sourced once at startup); `plugins/*.sh` are the per-update scripts referenced by `script=` on items.

## Neovim (AstroNvim v5)

`nvim/init.lua` bootstraps Lazy → requires `lazy_setup` → `polish`. Plugin spec is layered:

- `nvim/lua/lazy_setup.lua` pins `AstroNvim/AstroNvim` to `^5` and imports `astronvim.plugins` + `community` + `plugins`.
- `nvim/lua/community.lua` selects AstroCommunity language packs and modules (rust, gleam, python, lua, tailwind, typescript, elixir-phoenix, etc.) — add new community imports here.
- `nvim/lua/plugins/*.lua` are user overrides. **Most ship with `if true then return {} end` as the first line** — that's an AstroNvim template guard to keep the example inert. Remove that line only when you actually intend to enable the override.
- Leader is `<Space>`, localleader is `,` (set in `lazy_setup.lua` before Lazy loads — don't move).

Lua linting is configured via `nvim/selene.toml` (selene with `std = "neovim"` and several rules allowed). Formatter is stylua (some files mark `-- stylua: ignore` blocks).

## Hammerspoon module pattern

Each file in `hammerspoon/modules/` returns a table with `M.init()` (and sometimes a `watcherCallback` for audio device events). `init.lua` requires each module and calls `.init()`. The commented-out `sox` lines and `hs.audiodevice.watcher` block show the pattern for adding a watcher-driven module: write `watcherCallback`, then combine it with others via `util.combineFns`.

Spoons live in `hammerspoon/Spoons/`. `EmmyLua.spoon` autogenerates the `annotations/*.lua` API stubs used by lua-language-server — the noisy diffs on those files after a Hammerspoon update are expected, not changes to commit thoughtfully.
