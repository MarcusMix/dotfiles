#!/usr/bin/env bash
# 85 — Terminal: Alacritty, Konsole, prompt Starship, fish, fastfetch e btop
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Terminal"

# --- Alacritty ---------------------------------------------------------------
github_tarball catppuccin/alacritty "$CACHE_DIR/cat-alacritty"
mkdir -p "$CFG/alacritty"
cp "$CACHE_DIR/cat-alacritty/catppuccin-${FLAVOR}.toml" "$CFG/alacritty/catppuccin.toml"
cp "$RICE_DIR/config/alacritty/alacritty.toml" "$CFG/alacritty/alacritty.toml"
ok "Alacritty: Catppuccin ${FLAVOR_CAP}, JetBrains Mono, transparência com desfoque"

# --- Konsole (para quem usa) --------------------------------------------------
github_tarball catppuccin/konsole "$CACHE_DIR/cat-konsole"
mkdir -p "$DATA/konsole"
cp "$CACHE_DIR"/cat-konsole/themes/catppuccin-"${FLAVOR}".colorscheme "$DATA/konsole/" 2>/dev/null || true
cat > "$DATA/konsole/Mocha Rice.profile" <<EOF
[Appearance]
ColorScheme=catppuccin-${FLAVOR}
Font=${FONTE_MONO},11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
LineSpacing=2

[General]
Name=Mocha Rice
Parent=FALLBACK/
TerminalMargin=14

[Scrolling]
ScrollBarPosition=2
EOF
kw konsolerc "Desktop Entry" DefaultProfile "Mocha Rice.profile"
ok "Konsole: perfil Mocha Rice"

# --- Starship (prompt) --------------------------------------------------------
if ! tem starship && [[ ! -x "$BIN/starship" ]]; then
  baixar "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz" "$CACHE_DIR/starship.tar.gz"
  tar -xzf "$CACHE_DIR/starship.tar.gz" -C "$BIN" starship
fi
STARSHIP=$(command -v starship || echo "$BIN/starship")
"$STARSHIP" preset catppuccin-powerline -o "$CFG/starship.toml"
sed -i "s/^palette = .*/palette = 'catppuccin_${FLAVOR}'/" "$CFG/starship.toml"
ok "Starship com o preset catppuccin-powerline"

# --- fish ---------------------------------------------------------------------
if tem fish; then
  mkdir -p "$CFG/fish/conf.d"
  cp "$RICE_DIR/config/fish/kde-mocha-rice.fish" "$CFG/fish/conf.d/kde-mocha-rice.fish"
  ok "fish: cores Catppuccin + Starship"
fi
# bash e zsh: só acrescenta o Starship (com marcador, fácil de remover)
for rc in "$HOME/.bashrc:bash" "$HOME/.zshrc:zsh"; do
  arq=${rc%%:*} sh=${rc##*:}
  if [[ -f "$arq" ]] && ! grep -q 'kde-mocha-rice' "$arq"; then
    printf '\n# kde-mocha-rice\n[ -x "$HOME/.local/bin/starship" ] && export PATH="$HOME/.local/bin:$PATH"\ncommand -v starship >/dev/null && eval "$(starship init %s)"\n' "$sh" >> "$arq"
    ok "$sh: Starship"
  fi
done

# --- fastfetch ----------------------------------------------------------------
mkdir -p "$CFG/fastfetch"
cp "$RICE_DIR/config/fastfetch/config.jsonc" "$CFG/fastfetch/config.jsonc"
ok "fastfetch com cores Catppuccin"

# --- btop ---------------------------------------------------------------------
if tem btop; then
  github_tarball catppuccin/btop "$CACHE_DIR/cat-btop"
  mkdir -p "$CFG/btop/themes"
  cp "$CACHE_DIR/cat-btop/themes/catppuccin_${FLAVOR}.theme" "$CFG/btop/themes/"
  if [[ -f "$CFG/btop/btop.conf" ]]; then
    sed -i "s|^color_theme = .*|color_theme = \"$CFG/btop/themes/catppuccin_${FLAVOR}.theme\"|; s|^theme_background = .*|theme_background = False|; s|^rounded_corners = .*|rounded_corners = True|" "$CFG/btop/btop.conf"
  else
    printf 'color_theme = "%s"\ntheme_background = False\nrounded_corners = True\n' "$CFG/btop/themes/catppuccin_${FLAVOR}.theme" > "$CFG/btop/btop.conf"
  fi
  ok "btop: Catppuccin ${FLAVOR_CAP}"
fi
