# Hyprland Colorful Dots

Dotfiles (konfigurasi) Hyprland dengan tema warna-warni. Termasuk konfigurasi Hyprland, Waybar, Dunst, Rofi, SwayNC, Kitty, dan utilitas script (brightness, volume, clipboard, dsb).

Preview:
![2024-07-20-101604_hyprshot](https://github.com/user-attachments/assets/a868e017-439d-4169-9af9-dec039d1288c)
![2024-07-20-101550_hyprshot](https://github.com/user-attachments/assets/b77d6712-f51e-42bd-b7b1-e20d851a1ea4)

Catatan: config ini belum 100% selesai, tapi sudah usable dan bisa kamu sesuaikan.

--------------------------------------------------------------------------------

## Isi Repo

- `dotconfig/hypr` — konfigurasi Hyprland, Hypridle, Hyprlock, Hyprpaper, dan scripts
- `dotconfig/waybar` — konfigurasi Waybar (config + style.css)
- `dotconfig/dunst` — konfigurasi Dunst (notifikasi)
- `dotconfig/rofi` — launcher, theme, dan scripts Rofi
- `dotconfig/swaync` — konfigurasi Sway Notification Center
- `dotconfig/kitty` — konfigurasi terminal Kitty
- `dotconfig/fish`, `dotconfig/omf` — shell Fish + Oh My Fish (opsional)
- `dotconfig/wofi`, `dotconfig/waypaper`, `dotconfig/bat`, `dotconfig/dconf` — utilitas lain

--------------------------------------------------------------------------------

## Paket yang Dibutuhkan

Daftar paket di bawah adalah nama generik. Silakan sesuaikan dengan distro kamu (Arch, Fedora, Debian/Ubuntu, Nix, dll). Contoh perintah untuk Arch ada di bagian instalasi.

Wajib (inti Wayland/Hyprland + komponen utama):
- hyprland, hyprpaper, hypridle, hyprlock
- waybar
- dunst, libnotify (notify-send)
- rofi (versi Wayland) + cliphist + wl-clipboard (wl-copy, wl-paste)
- grim + slurp + swappy (screenshot area + editor)
- brightnessctl (kontrol brightness)
- pamixer (kontrol volume)
- playerctl (kontrol media)
- NetworkManager + network-manager-applet (nm-applet)
- blueman (bluetooth-applet)
- pipewire + pipewire-pulse + wireplumber (audio di Wayland)
- polkit agent: pilih salah satu
  - polkit-gnome (polkit-gnome-authentication-agent-1)
  - atau polkit-kde-agent (polkit-kde-authentication-agent-1)

Aplikasi default (sesuai `configs/default_apps.conf`):
- kitty (terminal)
- thunar (file manager)
- chromium (browser) — ganti sesuai selera

Tambahan yang dipakai config:
- waypaper (restore wallpaper, integrasi hyprpaper)
- swaync (notification center, dipanggil via `swaync-client`)
- qalc (kalkulator rofi) — paket: libqalculate/qalculate-gtk
- tofi (opsional, untuk clipboard menu `SUPER+V` di keybinds)
- qt5ct (karena `env.conf` set `QT_QPA_PLATFORMTHEME=qt5ct`)
- Tema/Font:
  - GTK theme: WhiteSur-Dark (opsional, lihat `env.conf`)
  - Nerd Fonts (ikon di Waybar), misal: `ttf-nerd-fonts-symbols`
  - Font "MonoLisa static" digunakan di Dunst/Waybar (ganti ke font yang kamu punya jika tidak tersedia)

Catatan:
- `startup_apps.conf` menjalankan dua polkit agent (gnome dan kde). Disarankan aktifkan satu saja sesuai desktop kamu.
- Dunst scripts (volume/brightness) mengarah ke ikon `~/.config/dunst/icons/*.svg`. Siapkan ikon sendiri atau ubah script/icon path.

--------------------------------------------------------------------------------

## Instalasi

Contoh di bawah untuk Arch-based distro. Untuk distro lain, gunakan nama paket yang sama/sesuai.

1) Install paket
- Arch (contoh, sesuaikan):
  - Core
    sudo pacman -S hyprland hyprpaper hypridle hyprlock waybar dunst rofi cliphist wl-clipboard grim slurp swappy brightnessctl pamixer playerctl network-manager-applet blueman pipewire pipewire-pulse wireplumber libnotify
  - Apps / utilitas tambahan
    sudo pacman -S kitty thunar chromium waypaper qalculate-gtk qt5ct
  - Polkit agent (pilih satu)
    sudo pacman -S polkit-gnome
    # atau
    sudo pacman -S polkit-kde-agent
  - Fonts/icons (opsional, untuk ikon)
    sudo pacman -S ttf-nerd-fonts-symbols
  - Opsional sesuai keybinds:
    # tofi (untuk SUPER+V clipboard)
    sudo pacman -S tofi
    # swaync (notification center)
    sudo pacman -S swaync

2) Clone repo
   git clone https://github.com/<user>/hyprland-colorful-dots.git
   cd hyprland-colorful-dots

3) Backup config lama (sangat disarankan)
   mkdir -p ~/.config_backup
   cp -r ~/.config/hypr ~/.config_backup/hypr_$(date +%s) 2>/dev/null || true
   cp -r ~/.config/waybar ~/.config_backup/waybar_$(date +%s) 2>/dev/null || true
   # ... backup yang lain sesuai kebutuhan

4) Salin dotfiles
- Cara cepat (salin semua isi `dotconfig` ke `~/.config`):
  rsync -avh dotconfig/ ~/.config/
  # atau
  cp -r dotconfig/* ~/.config/

- Setelah menyalin, pastikan script executable:
  chmod +x ~/.config/hypr/scripts/*.sh

5) Login ke Hyprland
- Pilih sesi Hyprland di display manager, atau start dari TTY:
  dbus-run-session Hyprland

--------------------------------------------------------------------------------

## Konfigurasi yang Perlu Disesuaikan

- Monitor names: `hypr/configs/monitors.conf`
  - Ganti `HDMI-A-1` / `eDP-1` sesuai output kamu (cek `hyprctl monitors`).
- Aplikasi default: `hypr/configs/default_apps.conf`
  - `$terminal`, `$fileManager`, `$browser`, `$menu`
- Startup apps: `hypr/configs/startup_apps.conf`
  - Pilih salah satu polkit agent (komentari yang tidak dipakai).
  - Pastikan semua aplikasi yang dieksekusi sudah terpasang (`waybar`, `dunst`, `nm-applet`, `blueman-applet`, `waypaper`, `wl-paste`, dst).
- Environment: `hypr/configs/env.conf`
  - `GTK_THEME=WhiteSur-Dark` bisa kamu ganti.
  - `QT_QPA_PLATFORM=xcb` saat ini diset ke xcb; sesuaikan jika ingin native Wayland untuk Qt apps.
- Fonts:
  - Waybar/Dunst menggunakan "MonoLisa static". Ganti ke font yang kamu punya jika tidak tersedia.
  - Install Nerd Fonts untuk ikon di Waybar (misal `ttf-nerd-fonts-symbols`).
- Clipboard & kalkulator:
  - `cliphist` + `wl-clipboard` wajib untuk fitur clipboard.
  - `rofi_calculator.sh` butuh `qalc` (libqalculate/qalculate-gtk).
- Optional:
  - `tofi`: keybind `SUPER+V` menggunakan tofi; kalau tidak dipakai, hapus/keybind di `keybinds.conf`.
  - `swaync`: tombol `SUPER+N` toggle notification center; pastikan swaync terpasang atau hapus keybind.
  - `pyprland`: ada keybinds `pypr toggle term` dan `pypr zoom`; install Pyprland atau hapus keybind jika tidak digunakan.

--------------------------------------------------------------------------------

## Keybinds Utama (ringkas)

Mod key: `SUPER` (Windows key)

- Aplikasi:
  - SUPER + Return → buka terminal (`kitty`)
  - SUPER + K → buka browser (`chromium`)
  - SUPER + D / SPACE / A → launcher (`rofi`)
  - SUPER + T → toggle Waybar
- Jendela/WS:
  - SUPER + Q → kill window
  - SUPER + F → fullscreen
  - SUPER + W → toggle floating
  - SUPER + [Arrows] → pindah fokus
  - SUPER + SHIFT + [Arrows] → pindah jendela
  - SUPER + [1..0] → pindah workspace 1..10
  - SUPER + SHIFT + [1..0] → kirim window ke workspace 1..10
- Screenshot:
  - Print → pilih area (grim + slurp) dan edit (swappy)
- Brightness:
  - XF86MonBrightnessUp / Down → atur brightness (brightnessctl + Dunst)
- Volume:
  - XF86AudioRaiseVolume / LowerVolume / Mute → atur volume (pamixer + Dunst)
- Lainnya:
  - SUPER + N → toggle SwayNC (jika terpasang)
  - SUPER + SHIFT + P → keluar Hyprland
  - SUPER + S / SHIFT + S → special workspace “magic”
  - SUPER + ALT + V / C → clipboard manager / kalkulator rofi

Detail lengkap bisa dilihat di `hypr/configs/keybinds.conf`.

--------------------------------------------------------------------------------

## Troubleshooting

- Waybar/ikon tidak tampil dengan benar:
  - Pastikan font ikon (Nerd Fonts) terpasang, dan ganti font di `waybar/style.css` jika perlu.
- Notifikasi tidak muncul:
  - Pastikan `dunst` berjalan. Konfig startup sudah memanggil `dunst`.
- Clipboard history tidak jalan:
  - Pastikan `cliphist` terpasang dan proses `wl-paste --watch cliphist store` berjalan (ada di `startup_apps.conf`).
- Monitor tidak terdeteksi/blank:
  - Cek nama output via `hyprctl monitors` dan sesuaikan `monitors.conf`.
- Nvidia:
  - Di `env.conf` ada `WLR_NO_HARDWARE_CURSORS=1`. Sesuaikan variable WLR_* sesuai setup GPU kamu.

--------------------------------------------------------------------------------

## Lisensi

Gunakan, modifikasi, dan bagikan sesukamu. Kalau kamu publish ulang, beri kredit ke repo ini ya. :)

```
