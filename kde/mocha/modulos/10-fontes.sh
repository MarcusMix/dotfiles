#!/usr/bin/env bash
# 10 — Fontes: Inter (interface) e JetBrains Mono Nerd Font (terminal/código)
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Fontes"

DEST="$DATA/fonts/kde-mocha-rice"
mkdir -p "$DEST"

if ! fc-list : family | grep -qx "Inter"; then
  baixar "https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip" "$CACHE_DIR/Inter-4.1.zip"
  # versões estáticas: a família se chama "Inter" e os pesos funcionam bem no Qt
  for peso in Light Regular Medium SemiBold Bold; do
    unzip -oqj "$CACHE_DIR/Inter-4.1.zip" "extras/ttf/Inter-${peso}.ttf" "extras/ttf/Inter-${peso}Italic.ttf" -d "$DEST" 2>/dev/null
  done
  unzip -oqj "$CACHE_DIR/Inter-4.1.zip" "extras/ttf/Inter-Italic.ttf" -d "$DEST" 2>/dev/null
fi
ok "Inter"

if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
  baixar "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/JetBrainsMono.tar.xz" "$CACHE_DIR/JetBrainsMono.tar.xz"
  tar -xJf "$CACHE_DIR/JetBrainsMono.tar.xz" -C "$DEST" --wildcards 'JetBrainsMonoNerdFont-*.ttf'
fi
ok "JetBrains Mono Nerd Font"
fc-cache -f "$DEST" >/dev/null

# Formato de fonte do Qt 6: família,tamanho,-1,5,peso,itálico,...
f() { printf '%s,%s,-1,5,%s,0,0,0,0,0,0,0,0,0,0,1' "$1" "$2" "${3:-400}"; }
kw kdeglobals General font                 "$(f "$FONTE_INTERFACE" "$TAMANHO_FONTE")"
kw kdeglobals General menuFont             "$(f "$FONTE_INTERFACE" "$TAMANHO_FONTE")"
kw kdeglobals General toolBarFont          "$(f "$FONTE_INTERFACE" "$TAMANHO_FONTE")"
kw kdeglobals General smallestReadableFont "$(f "$FONTE_INTERFACE" $((TAMANHO_FONTE - 2)))"
kw kdeglobals General fixed                "$(f "$FONTE_MONO" "$TAMANHO_FONTE")"
kw kdeglobals WM      activeFont           "$(f "$FONTE_INTERFACE" "$TAMANHO_FONTE" 600)"
# Suavização: subpixel + hinting leve (texto mais nítido)
kw kdeglobals General XftAntialias true
kw kdeglobals General XftHintStyle hintslight
kw kdeglobals General XftSubPixel rgb
kw kcmfonts General forceFontDPI 0

# GTK (Firefox, apps GNOME) usa a mesma fonte
for v in gtk-3.0 gtk-4.0; do
  mkdir -p "$CFG/$v"
  kw "$CFG/$v/settings.ini" Settings gtk-font-name "$FONTE_INTERFACE, $TAMANHO_FONTE"
done
ok "fontes aplicadas no KDE e no GTK"
