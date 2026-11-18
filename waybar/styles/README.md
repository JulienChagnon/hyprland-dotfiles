# Waybar styles (SUPER+O > Style)

SUPER+O picks two things independently:

- **Colour** (top section): `themes/<COLOUR>.css` + `themes/<COLOUR>.jsonc`, plus
  `palettes/<COLOUR>.css` which defines `@accent` for non-PERSONAL styles.
- **Style** (bottom section): `PERSONAL` (built in, means "use the colour's own
  themes/*.css and *.jsonc as is") or any folder here holding `style.css` + `config.jsonc`.

The two `────` divider rows can't be chosen: picking one just reopens the menu.

For a non-PERSONAL style, `~/.local/bin/waybar-theme-picker` generates:

```
style.css    = themes/<COLOUR>.css + palettes/<COLOUR>.css + styles/<STYLE>/style.css
config.jsonc = styles/<STYLE>/config.jsonc   (then SUPER+I net/clock toggles re-applied)
```

`style.css` and `config.jsonc` in `~/.config/waybar/` are generated: edit the sources
and re-pick in SUPER+O, never edit the generated files.

## Rules for adding a style

Only take the *icon look* from someone else's bar, never their bar itself.

1. **Same modules, same ids.** Keep exactly: `hyprland/workspaces`, `clock`,
   `custom/weather`, `cpu`, `memory`, `pulseaudio`, `tray`, `custom/sep`,
   `custom/net-wifi`, `custom/net-eth`. Same `modules-left/center/right` lists as
   `styles/MINIMUM/config.jsonc`. SUPER+I rewrites those lists by regex, and the
   on-click/scroll actions must stay the same. Do not add their modules (battery,
   bluetooth, window title, power buttons...).
2. **Keep the data.** Change only the icon and the colours around the value. CPU %,
   RAM GB, volume %, weather temp, network rate keep their current format/intervals.
3. **Clock and date never change.** Copy the `clock` block verbatim from
   `styles/MINIMUM/config.jsonc` and never write a `#clock` rule in a style's CSS. It
   inherits from the colour theme.
4. **Icons follow the SUPER+O colour, text is white.** In config.jsonc wrap the value
   in `<span foreground='#ffffff'>` and leave the icon un-coloured (only a
   `font_family` span). In style.css set the module `color: @accent`. Never hard-code
   an icon colour, so one style works for every colour.
5. **Fixed width, icons never move** (applies to PERSONAL too). Do NOT pad values in
   the format (`{volume:>3}` puts spaces between icon and number, `{volume:<3}` puts
   them between number and `%`). Instead give every stat module
   `"min-length": N, "align": 0`: GTK reserves N characters (8 px each in Noto Sans
   Mono 13px) and left-aligns the text, so the icon sits one space from the number
   and the spare room goes after the unit. Pick N so `8 * N` px is at least the
   widest possible text (e.g. icon + "100%"). Current values: MINIMUM cpu 7, memory 9,
   pulseaudio 7, weather 7, net 9; PERSONAL 8, 10, 7, 9, 9.
   `format-muted` keeps the same layout as `format` (icon + number), never empty: an
   empty format hides the module and shifts the whole bar.
   Icons whose glyph changes with state must keep their drawing in the same spot:
   use `Symbols Nerd Font Mono` (equal cells) and pick glyphs from one family drawn on
   one grid. For volume that means Material Design (U+F057F/F0580/F057E, off
   U+F0581); the Font Awesome f026/f027/f028 set moves the speaker sideways.
6. **Network icons are shared.** wifi/ethernet always use the PERSONAL Font Awesome
   glyphs (``, ``), drawn by `~/.local/bin/waybar-net`. A style only
   picks the value colour and whether down links are hidden (pass the style name as
   3rd arg; MINIMUM hides them by printing an empty line).
7. **Workspaces are numbers** (`"format": "{id}"`, persistent 15). Only the button look
   may change. If you style `#workspaces button` with `window#waybar`, re-add the
   "hide empty / 11-15" block at the end (see MINIMUM/style.css), or empty desktops
   reappear.
8. **CSS is an override layer**, not a full sheet: prefix selectors with
   `window#waybar` so they beat the colour CSS.
9. **Names**: style folders are UPPERCASE, must not equal a colour name (the picker
   decides colour vs style by `themes/<name>.css` existing) and must not contain `──`
   (that marks a divider row).
10. **Weather icon**: add a `--style <NAME>` branch in `~/.local/bin/waybar-weather` if
    the style needs single-colour glyphs (colour emoji can't be tinted by CSS).
11. **Glyphs in config.jsonc**: write them as `\uXXXX` escapes (characters above
    U+FFFF as a surrogate pair, e.g. U+F0581 = `󰖁`). Literal private-use
    characters are invisible in most editors and can't be matched by edit tools.
12. **New colour?** Also add `palettes/<COLOUR>.css` (`@define-color accent #rrggbb;`)
    and a case in `~/.local/bin/hypr-border-sync`.

## Existing styles

| Style | Source | Notes |
|-------|--------|-------|
| PERSONAL | this machine | Colour-specific themes/*.css and *.jsonc |
| MINIMUM | newemperor221/hyprland-dotfiles, `hypr_style1/waybar` | His Nerd Font icons (Mono) tinted `@accent`, white values, no rails; his workspace pill (grey numbers, accent fill when active); only connected NICs shown |
