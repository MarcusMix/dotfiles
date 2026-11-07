#!/usr/bin/env bash
# 20 — Cores (esquema Catppuccin) + estilo dos aplicativos (Kvantum) + GTK
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Cores e estilo dos aplicativos"

# --- esquema de cores do KDE ------------------------------------------------
ESQUEMA="Catppuccin${FLAVOR_CAP}${ACCENT_CAP}"
baixar "https://github.com/catppuccin/kde/releases/download/v0.4.0/${FLAVOR_CAP}-color-schemes.tar.gz" \
       "$CACHE_DIR/${FLAVOR}-colors.tar.gz"
mkdir -p "$DATA/color-schemes"
tar -xzf "$CACHE_DIR/${FLAVOR}-colors.tar.gz" -C "$DATA/color-schemes" --strip-components=1 \
    "${FLAVOR_CAP}-color-schemes/${ESQUEMA}.colors"
# aplica (troca para outro e volta, para forçar a atualização se já estava ativo)
if [[ "$(kr kdeglobals General ColorScheme)" == "$ESQUEMA" ]]; then plasma-apply-colorscheme BreezeDark >/dev/null 2>&1; fi
plasma-apply-colorscheme "$ESQUEMA" >/dev/null && ok "esquema de cores $ESQUEMA"
kw kdeglobals General AccentColor ""          # usa o destaque do próprio esquema
kw kdeglobals General accentColorFromWallpaper false

# --- Kvantum (estilo dos aplicativos Qt) ------------------------------------
KV="catppuccin-${FLAVOR}-${ACCENT}"
github_tarball catppuccin/kvantum "$CACHE_DIR/kvantum"
mkdir -p "$CFG/Kvantum"
rm -rf "${CFG:?}/Kvantum/$KV" && cp -r "$CACHE_DIR/kvantum/themes/$KV" "$CFG/Kvantum/"
# Ajustes: janelas um pouco translúcidas com desfoque atrás (só menus e popups)
kw "$CFG/Kvantum/$KV/$KV.kvconfig" "%General" translucent_windows false
kw "$CFG/Kvantum/$KV/$KV.kvconfig" "%General" blurring true
kw "$CFG/Kvantum/$KV/$KV.kvconfig" "%General" popup_blurring true
kw "$CFG/Kvantum/$KV/$KV.kvconfig" "%General" menu_shadow_depth 6
kw "$CFG/Kvantum/kvantum.kvconfig" General theme "$KV"

if [[ -e /usr/lib/qt6/plugins/styles/libkvantum.so ]] || ls /usr/lib*/qt6/plugins/styles/*kvantum* >/dev/null 2>&1; then
  kw kdeglobals KDE widgetStyle kvantum
  ok "estilo dos apps: Kvantum ($KV)"
else
  kw kdeglobals KDE widgetStyle Breeze
  aviso "Kvantum não instalado: apps ficam no Breeze com as cores Catppuccin (rode o módulo 00)"
fi

# --- GTK: Breeze-GTK segue as cores do KDE; aqui só tema escuro e ícones -----
for v in gtk-3.0 gtk-4.0; do
  kw "$CFG/$v/settings.ini" Settings gtk-application-prefer-dark-theme "$([[ $FLAVOR == latte ]] && echo false || echo true)"
  kw "$CFG/$v/settings.ini" Settings gtk-theme-name Breeze
done
ok "GTK no escuro"
