#!/usr/bin/env bash
# 90 — Lançador estilo Raycast: Vicinae (Meta+Espaço)
#  Apps, calculadora, histórico da área de transferência, emojis, arquivos,
#  conversões, atalhos de sistema e extensões (inclusive da loja do Raycast).
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Lançador Vicinae"

VER=v0.29.2
if ! tem vicinae && [[ ! -x "$BIN/vicinae" ]]; then
  baixar "https://github.com/vicinaehq/vicinae/releases/download/$VER/Vicinae-x86_64.AppImage" "$CACHE_DIR/Vicinae-x86_64.AppImage"
  install -m 755 "$CACHE_DIR/Vicinae-x86_64.AppImage" "$BIN/vicinae"
fi
VIC=$(command -v vicinae || echo "$BIN/vicinae")
ok "Vicinae instalado em $VIC"

# --- configuração -------------------------------------------------------------
mkdir -p "$CFG/vicinae"
cat > "$CFG/vicinae/settings.json" <<EOF
// kde-mocha-rice — veja todas as opções com: vicinae config default
{
  "\$schema": "https://vicinae.com/schemas/config.json",
  "telemetry": { "system_info": false },
  "pop_to_root_on_close": true,
  "font": { "normal": { "family": "${FONTE_INTERFACE}" } },
  "theme": {
    "dark":  { "name": "catppuccin-${FLAVOR/latte/mocha}", "icon_theme": "Papirus-Dark" },
    "light": { "name": "catppuccin-latte", "icon_theme": "Papirus-Light" }
  },
  "launcher_window": {
    "opacity": 0.92,
    "rounding": 16,
    "client_side_decorations": { "enabled": true, "border_width": 1 },
    "size": { "width": 780, "height": 480 }
  }
}
EOF
ok "tema catppuccin-${FLAVOR}, vidro fosco, cantos de 16px"

# --- sobe junto com a sessão --------------------------------------------------
mkdir -p "$CFG/autostart"
cat > "$CFG/autostart/kde-mocha-rice-vicinae.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Vicinae
Comment=Servidor do lançador (kde-mocha-rice)
Exec=$VIC server
Icon=system-search
X-KDE-autostart-phase=2
EOF

# --- atalho global (Meta+Espaço) pelo próprio KDE ------------------------------
mkdir -p "$DATA/applications"
cat > "$DATA/applications/kde-mocha-rice-vicinae.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Vicinae (abrir/fechar)
Comment=Lançador estilo Raycast — kde-mocha-rice
Exec=$VIC toggle
Icon=system-search
NoDisplay=true
X-KDE-GlobalAccel-CommandShortcut=true
X-KDE-Shortcuts=${ATALHO_LANCADOR}
EOF
update-desktop-database -q "$DATA/applications" 2>/dev/null || true
ID=(kde-mocha-rice-vicinae.desktop _launch "Vicinae (abrir/fechar)" "Vicinae (abrir/fechar)")
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel doRegister as 4 "${ID[@]}" >/dev/null 2>&1 \
  && ok "atalho ${ATALHO_LANCADOR} abre o Vicinae" \
  || aviso "registre o atalho em Configurações > Atalhos > Adicionar comando: $VIC toggle"

# inicia agora (se ainda não estiver rodando)
if ! "$VIC" ping >/dev/null 2>&1; then (setsid "$VIC" server >/dev/null 2>&1 &); fi
