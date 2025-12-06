# Hyprland Colorful Dots

Colorful, modular Hyprland dotfiles. Includes Hyprland, Waybar, Dunst, Rofi, SwayNC, Kitty, and useful Wayland scripts (volume, brightness, clipboard, screenshots, etc.).

Preview:
https://github.com/user-attachments/assets/a868e017-439d-4169-9af9-dec039d1288c
https://github.com/user-attachments/assets/b77d6712-f51e-42bd-b7b1-e20d851a1ea4

Note: This configuration is usable, but not 100% “finished.” Tune it to your setup.

--------------------------------------------------------------------------------

## Repository Layout

- `dotconfig/hypr` — Hyprland configs and scripts:
  - `hyprland.conf` includes: `startup_apps.conf`, `settings.conf`, `env.conf`, `inputs.conf`, `monitors.conf`, `default_apps.conf`, `keybinds.conf`, `window_rules.conf`
  - `hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf`
  - `scripts/` helpers: brightness, volume, clipboard manager, calculator, waybar toggle, etc.
- `dotconfig/waybar` — Waybar `config` and `style.css`
- `dotconfig/dunst` — Dunst `dunstrc` and expected icons directory
- `dotconfig/rofi` — Rofi themes, launchers, and scripts
- `dotconfig/swaync` — SwayNC configuration (optional)
- `dotconfig/kitty` — Kitty terminal config
- `dotconfig/fish`, `dotconfig/omf` — Fish shell and Oh-My-Fish (optional)
- Others: `dotconfig/wofi`, `dotconfig/waypaper`, `dotconfig/bat`, `dotconfig/dconf`

--------------------------------------------------------------------------------

## Requirements

Names below are generic; install them using your distro’s package manager.
Optional items are marked. Some keybinds or scripts expect these to exist.

Core (Wayland + Hyprland + panel/notifications):
- hyprland, hyprpaper, hypridle, hyprlock
- waybar
- dunst, libnotify (notify-send)

Launchers, clipboard, screenshots:
- rofi (Wayland build)
- cliphist, wl-clipboard (wl-copy, wl-paste)
- grim, slurp, swappy

System controls:
- brightnessctl
- pamixer
- playerctl

Network, bluetooth, audio stack:
- NetworkManager + network-manager-applet (nm-applet)
- blueman (blueman-applet)
- pipewire, pipewire-pulse, wireplumber

Polkit agent (choose one):
- polkit-gnome (polkit-gnome-authentication-agent-1)
- OR polkit-kde-agent (polkit-kde-authentication-agent-1)

Default apps (as referenced in configs):
- kitty (terminal)
- thunar (file manager)
- chromium (browser) — replace with your preferred browser if you like

Extras used by configs/scripts:
- waypaper (wallpaper manager; integrates with hyprpaper)
- swaync (notification center; used by a keybind)
- qalculate-gtk or libqalculate (for Rofi calculator script `qalc`)
- tofi (optional; clipboard selector variant)
- qt5ct (QT_QPA_PLATFORMTHEME=qt5ct in env)

Fonts and icons:
- Nerd Fonts (for Waybar glyphs), e.g. Symbols Nerd Font
- A monospace font; the sample uses “MonoLisa static” in Dunst/Waybar (replace with a font you have installed)

Python / Pyprland (optional):
- Some keybinds reference `pypr toggle term` and `pypr zoom`. Install Pyprland or remove those binds.

--------------------------------------------------------------------------------

## Quick Start (Arch-based example)

Adjust to your distro. This is a reference, not an exhaustive list.

Core
```
sudo pacman -S hyprland hyprpaper hypridle hyprlock waybar dunst libnotify \
  rofi cliphist wl-clipboard grim slurp swappy brightnessctl pamixer playerctl \
  network-manager-applet blueman pipewire pipewire-pulse wireplumber
```

Apps and extras
```
sudo pacman -S kitty thunar chromium waypaper qalculate-gtk qt5ct swaync tofi
```

Polkit agent (pick one)
```
sudo pacman -S polkit-gnome
# or
sudo pacman -S polkit-kde-agent
```

Fonts
```
sudo pacman -S ttf-nerd-fonts-symbols
# Install your preferred monospace font and adjust configs if needed
```

--------------------------------------------------------------------------------

## Installation

1) Clone the repo
```
git clone https://github.com/<your-user>/hyprland-colorful-dots.git
cd hyprland-colorful-dots
```

2) Back up your current configs (recommended)
```
mkdir -p ~/.config_backup
cp -r ~/.config/hypr ~/.config_backup/hypr_$(date +%s) 2>/dev/null || true
cp -r ~/.config/waybar ~/.config_backup/waybar_$(date +%s) 2>/dev/null || true
# Repeat for others as needed
```

3) Copy the dotfiles
- Copy everything from `dotconfig/` into `~/.config/`
```
rsync -avh dotconfig/ ~/.config/
# or
cp -r dotconfig/* ~/.config/
```

4) Make scripts executable
```
chmod +x ~/.config/hypr/scripts/*.sh
```

5) Start Hyprland
- From a display manager: pick “Hyprland”
- From TTY:
```
dbus-run-session Hyprland
```

--------------------------------------------------------------------------------

## Configuration Notes

Hyprland includes:
- `hyprland.conf` that sources all partial configs in `hypr/configs/`
- Adjust the following to match your environment:

Displays
- `~/.config/hypr/configs/monitors.conf`
  - Replace `HDMI-A-1` / `eDP-1` with your actual outputs:
  ```
  hyprctl monitors
  ```
  - Example:
  ```
  monitor = HDMI-A-1,preferred,auto,1
  monitor = eDP-1,preferred,auto,1
  ```

Environment
- `~/.config/hypr/configs/env.conf`
  - `GTK_THEME=WhiteSur-Dark` can be changed to your GTK theme
  - `QT_QPA_PLATFORM` is set to `xcb` in this config; change to `wayland` if your QT apps work better on Wayland
  - `QT_QPA_PLATFORMTHEME=qt5ct` implies you should have `qt5ct` installed
  - Wayland variables for cursor and DRM are included; tune for iGPU/dGPU setups if needed

Default apps
- `~/.config/hypr/configs/default_apps.conf`
  - Terminal: `kitty`
  - File manager: `thunar`
  - Browser: `chromium`
  - Launcher: `rofi`

Autostart
- `~/.config/hypr/configs/startup_apps.conf`
  - Starts: Waybar, Dunst, Waypaper, nm-applet, blueman-applet, cliphist watcher, polkit agent(s)
  - IMPORTANT: Only use one polkit agent (GNOME or KDE). Comment out the other.
  - If you don’t use certain services (e.g., Waypaper), comment out their `exec-once` lines.

Scripts
- Located at `~/.config/hypr/scripts/`
  - `brightness.sh` (brightnessctl + Dunst notify)
  - `volume.sh` (pamixer + Dunst notify)
  - `clip_manager.sh` (rofi + cliphist + wl-clipboard)
  - `rofi_calculator.sh` (rofi + qalc)
  - `waybar-toggle.sh` (toggle Waybar process)
  - `refresh.sh` (custom refresh hook)
- Dunst icons:
  - Scripts expect icons at `~/.config/dunst/icons/*.svg`. Provide matching icons or change the paths in scripts.

Waybar
- `~/.config/waybar/config` and `style.css`
  - Uses icons/glyphs that require Nerd Fonts
  - Tweak modules, formats, and colors in `config` and `style.css` as desired

Dunst
- `~/.config/dunst/dunstrc`
  - Font is set to “MonoLisa static 12” — replace with a font available on your system

Rofi
- `~/.config/rofi/` contains launchers, themes, and scripts
  - Keybinds call a “type-3” launcher script; ensure path and themes exist

SwayNC (optional)
- Some keybinds use `swaync-client` to toggle the notification center
  - Install `swaync` or remove the keybind

Pyprland (optional)
- Keybinds reference `pypr toggle term` and `pypr zoom`
  - Install Pyprland and configure it, or remove those lines in `keybinds.conf`

--------------------------------------------------------------------------------

## Keybind Summary

Mod key: `SUPER` (Windows key)

Launchers and apps
- SUPER + Return → terminal (kitty)
- SUPER + K → browser (chromium)
- SUPER + D → app launcher (rofi drun)
- SUPER + Space → rofi launcher (theme script)
- SUPER + A → rofi launcher (theme script)
- SUPER + ALT + V → clipboard manager (rofi + cliphist)
- SUPER + ALT + C → rofi calculator (qalc)
- SUPER + T → toggle Waybar

Session/window
- SUPER + Q → close window
- SUPER + M → exit Hyprland
- SUPER + SHIFT + P → hyprctl exit
- SUPER + F → fullscreen
- SUPER + W → toggle floating
- SUPER + P → pseudo tile (dwindle)
- SUPER + J → toggle split (dwindle)

Focus and movement
- SUPER + Arrow keys → move focus
- SUPER + SHIFT + Arrow keys → move window
- SUPER + ALT + Left/Right → move current workspace to monitor Left/Right

Resize
- ALT + SHIFT + Arrow keys → resize active window

Workspaces
- SUPER + 1..0 → switch to workspace 1..10
- SUPER + SHIFT + 1..0 → move to workspace 1..10
- SUPER + SHIFT + [ / ] → move to previous/next workspace
- SUPER + S → toggle special workspace “magic”
- SUPER + SHIFT + S → move to special workspace “magic”
- Mouse: SUPER + left-drag → move window
- Mouse: SUPER + right-drag → resize window
- SUPER + mouse scroll → cycle workspaces

Media, brightness, volume
- Print → region screenshot → swappy editor
- Brightness: XF86MonBrightnessUp / XF86MonBrightnessDown
- Volume: XF86AudioRaiseVolume / XF86AudioLowerVolume / XF86AudioMute
- SUPER + N → playerctl play/pause (NOTE: another bind uses SUPER + N for SwayNC toggle; choose one)

Workspaces (extra)
- SUPER + X → workspace m+1
- SUPER + Z → workspace m-1
- Pyprland (optional):
  - SUPER + SHIFT + Return → `pypr toggle term`
  - SUPER + Z → `pypr zoom` (conflicts with workspace m-1 above; pick one)

Conflicts to resolve
- SUPER + N is bound both to playerctl and SwayNC toggle. Keep one.
- SUPER + Z is bound to both Pyprland zoom and workspace navigation. Keep one.

Edit `~/.config/hypr/configs/keybinds.conf` to resolve/adjust.

--------------------------------------------------------------------------------

## Troubleshooting

- Waybar icons/symbols look wrong:
  - Install Nerd Fonts and set a proper font in `style.css`
- No notifications:
  - Ensure `dunst` is running (autostart spawns it)
- Clipboard history not working:
  - Make sure `cliphist` is installed and the watcher is running:
    - `wl-paste --watch cliphist store` (autostart spawns it)
- Displays wrong/off:
  - Adjust `monitors.conf` to your outputs (`hyprctl monitors`)
- QT apps look off:
  - Try setting `QT_QPA_PLATFORM=wayland` in `env.conf` (and keep `qt5ct` if needed)
- Nvidia/hybrid:
  - Tune WLR_* variables in `env.conf` for your GPU setup

--------------------------------------------------------------------------------

## Notes

- Feel free to change default applications in `default_apps.conf`
- Use only one polkit agent in `startup_apps.conf`
- Replace fonts referenced in Waybar/Dunst with ones available on your system

Enjoy, and customize to your taste!
