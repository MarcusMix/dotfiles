#!/usr/bin/env bash
# 40 — Ícones Papirus-Dark com pastas Catppuccin + cursor Catppuccin
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Ícones e cursor"

ICONES="$DATA/icons"
mkdir -p "$ICONES"

# --- Papirus (instalado no seu usuário, sem sudo) ---------------------------
if [[ ! -f "$ICONES/Papirus/index.theme" ]]; then
  github_tarball PapirusDevelopmentTeam/papirus-icon-theme "$CACHE_DIR/papirus"
  for t in Papirus Papirus-Dark; do
    rm -rf "${ICONES:?}/$t" && cp -r "$CACHE_DIR/papirus/$t" "$ICONES/"
  done
  rm -rf "$CACHE_DIR/papirus"
fi
ok "Papirus-Dark"

# --- pastas na cor do destaque (catppuccin/papirus-folders) -----------------
github_tarball catppuccin/papirus-folders "$CACHE_DIR/papirus-folders-cat"
cp -r "$CACHE_DIR/papirus-folders-cat/src/." "$ICONES/Papirus/"
baixar "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders" "$BIN/papirus-folders"
chmod +x "$BIN/papirus-folders"
"$BIN/papirus-folders" -C "cat-${FLAVOR}-${ACCENT}" --theme Papirus-Dark >/dev/null \
  && ok "pastas cat-${FLAVOR}-${ACCENT}" || aviso "papirus-folders falhou (pastas ficam azuis)"
gtk-update-icon-cache -q -f "$ICONES/Papirus-Dark" 2>/dev/null || true

TEMA_ICONES=$([[ $FLAVOR == latte ]] && echo Papirus-Light || echo Papirus-Dark)
if [[ -x /usr/lib/plasma-changeicons ]]; then /usr/lib/plasma-changeicons "$TEMA_ICONES" >/dev/null 2>&1
else kw kdeglobals Icons Theme "$TEMA_ICONES"; fi
for v in gtk-3.0 gtk-4.0; do kw "$CFG/$v/settings.ini" Settings gtk-icon-theme-name "$TEMA_ICONES"; done
ok "ícones aplicados"

# --- cursor -----------------------------------------------------------------
CURSOR="catppuccin-${FLAVOR}-${ACCENT}-cursors"
if [[ ! -d "$ICONES/$CURSOR" ]]; then
  baixar "https://github.com/catppuccin/cursors/releases/download/v2.0.0/${CURSOR}.zip" "$CACHE_DIR/${CURSOR}.zip"
  unzip -oq "$CACHE_DIR/${CURSOR}.zip" -d "$ICONES"
fi
plasma-apply-cursortheme "$CURSOR" >/dev/null 2>&1
kw kcminputrc Mouse cursorTheme "$CURSOR"
kw kcminputrc Mouse cursorSize 24
# apps X11/GTK antigos
mkdir -p "$HOME/.icons/default"
printf '[Icon Theme]\nInherits=%s\n' "$CURSOR" > "$HOME/.icons/default/index.theme"
for v in gtk-3.0 gtk-4.0; do
  kw "$CFG/$v/settings.ini" Settings gtk-cursor-theme-name "$CURSOR"
  kw "$CFG/$v/settings.ini" Settings gtk-cursor-theme-size 24
done
ok "cursor $CURSOR"
