# Noctalia Shell Configuration

## Overview

Noctalia Shell is a modern desktop shell for Wayland compositors with launcher, notifications, calendar, and quick settings.

## Files

- `colors.json` - Color scheme (dark theme)
- `settings.json` - General settings and behavior
- `plugins.json` - Plugin configuration

## Auto-Start

Noctalia Shell is automatically started with Niri via `config/niri/config.kdl`:

```kdl
spawn-at-startup "noctalia-shell"
```

## Keybindings

Default shortcuts (configured in Niri):

- `Mod+Space` - Open launcher
- `Mod+N` - Toggle notifications
- `Mod+C` - Open calendar
- `Mod+P` - Open quick settings

## Customization

### Change Colors

Edit `colors.json` to customize the color scheme. Uses base16 color format.

### Adjust Settings

Edit `settings.json` for:
- Panel position and height
- Animation speed
- Transparency and blur
- Widget behavior
- Keybindings

### Enable/Disable Plugins

Edit `plugins.json` to enable or disable features:

```json
{
  "name": "weather",
  "enabled": false  // Change to true to enable
}
```

## Features

- 🚀 **Launcher** - Fuzzy search for apps, files, commands
- 🔔 **Notifications** - Modern notification system
- 📅 **Calendar** - Built-in calendar widget
- ⚙️ **Quick Settings** - Network, Bluetooth, Audio, etc.
- 🎨 **System Tray** - Application tray icons
- 🕒 **Clock** - Date and time display
- 🖥️ **Workspaces** - Workspace indicator

## Troubleshooting

### Shell not starting?

Check if it's running:
```bash
pgrep noctalia-shell
```

Restart manually:
```bash
pkill noctalia-shell
noctalia-shell &
```

### Keybindings not working?

Make sure Niri config is loaded:
```bash
niri msg version
```

Reload Niri config:
```bash
niri msg reload-config
```

### Reset to defaults

Backup and remove config:
```bash
mv ~/.config/noctalia ~/.config/noctalia.backup
# Rebuild to restore default configs
sudo nixos-rebuild switch --flake .#hostname
```

## Links

- [Noctalia Shell GitHub](https://github.com/noctalia-dev/noctalia-shell)
- [Niri Configuration](../niri/config.kdl)

---

**Enjoy your beautiful desktop shell! ✨**