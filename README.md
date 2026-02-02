# NixOS + Niri + Noctalia Shell - Universal Dotfiles

See full documentation at: https://github.com/yourusername/nixos-dotfiles

## Quick Start

1. Generate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/default/hardware-configuration.nix
   ```

2. Customize:
   - Edit `hosts/default/configuration.nix` (hostname, username)
   - Edit `hosts/default/home.nix` (username, home directory)
   - Edit `modules/home/git.nix` (git name, email)
   - Edit `modules/desktop/greetd.nix` (auto-login username)
   - Replace config files in `config/` with your actual configs

3. Build:
   ```bash
   sudo nixos-rebuild switch --flake .#default
   ```

4. Reboot and enjoy!
