{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty helix zed-editor vscode
    go rustup nodejs_22 python3 gcc
    gopls nodePackages.typescript-language-server nil
    nixfmt nodePackages.prettier  # ← đã đổi nixfmt-classic → nixfmt
    gh lazygit cmake gnumake pkg-config
    ripgrep fd eza bat zoxide fzf jq httpie curl wget
    starship
  ];
}
