# NixOS + Niri + Noctalia Shell - Beautiful Dotfiles 🎨

Modern NixOS configuration with automatic wallpaper management and beautiful login screen.

## ✨ Features

- 🪟 **Niri** - Scrollable-tiling Wayland compositor
- 🎨 **Auto Wallpaper** - Changes every 30 min with smooth transitions
- 🔐 **Beautiful Login** - Custom styled ReGreet
- 🐚 **Noctalia Shell** - Modern desktop shell
- 🛠️ **Dev Tools** - Helix, Git, Docker

## 🚀 Install

```bash
# 1. Clone
git clone https://github.com/your-username/river-dotfiles.git
cd river-dotfiles

# 2. Run installer (will ask for username, hostname, password, etc.)
./install.sh

# 3. Build (replace 'hostname' with what you entered)
sudo nixos-rebuild switch --flake .#hostname

# 4. Reboot
reboot
```

**That's it!** 🎉

## 📖 Docs

- **[INSTALL.md](INSTALL.md)** - Full guide
- **[WALLPAPER_SETUP.md](WALLPAPER_SETUP.md)** - Wallpaper help

## 🎨 Wallpapers

### Commands

```bash
# Change wallpaper randomly
wallpaper-manager random

# Next/Previous wallpaper
wallpaper-manager next
wallpaper-manager prev

# With effect
SWWW_TRANSITION=grow wallpaper-manager random
```

### Shortcuts

`Mod+Alt+W` - Random | `Mod+Alt+N` - Next | `Mod+Alt+B` - Prev

## 🐚 Noctalia Shell

### Features

- **Launcher** (`Mod+Space`) - Search apps, files, commands
- **Notifications** (`Mod+N`) - Notification center
- **Calendar** (`Mod+C`) - Date and events
- **Quick Settings** (`Mod+P`) - Network, Bluetooth, Audio, etc.

### Auto-Start

Noctalia Shell starts automatically with Niri. Config files in `config/noctalia/`:
- `colors.json` - Color scheme
- `settings.json` - Behavior and appearance
- `plugins.json` - Enable/disable features

See [config/noctalia/README.md](config/noctalia/README.md) for details.

## 🛠️ Customize

**Add wallpapers:**
```bash
cp your-images/*.jpg wallpapers/
sudo nixos-rebuild switch --flake .#hostname
```

**Change interval:** Edit `INTERVAL=1800` in `hosts/default/home.nix`

**Login style:** Edit `config/regreet/style.css`

**Keybindings:** Edit `config/niri/config.kdl`

## 🎯 What's Inside

- **Niri** - Wayland compositor
- **Noctalia Shell** - Desktop shell
- **Ghostty** - Terminal
- **Firefox** - Browser
- **Helix** - Text editor
- **Docker** - Containers
- **PipeWire** - Audio

## 🔧 Troubleshoot

**Build fails?** Try: `sudo nixos-rebuild switch --flake .#hostname --impure`

**Wallpaper stuck?** Run: `systemctl --user restart wallpaper-changer`

**No login wallpaper?** Run: `sudo login-wallpaper setup`

## 🙏 Credits

[Niri](https://github.com/YaLTeR/niri) • [Noctalia](https://github.com/noctalia-dev/noctalia-shell) • [swww](https://github.com/Horus645/swww) • [ReGreet](https://github.com/rharish101/ReGreet) • Neytirix (artwork)

---

**Enjoy! 🎨✨**