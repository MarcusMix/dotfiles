#!/usr/bin/env bash
# 30 — Estilo do Plasma "Mocha Glass" (painéis e popups de vidro fosco, cantos redondos)
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Estilo do Plasma"

DEST="$DATA/plasma/desktoptheme/mocha-glass"
rm -rf "$DEST" && mkdir -p "$(dirname "$DEST")"
cp -r "$RICE_DIR/assets/plasma-style/mocha-glass" "$DEST"
plasma-apply-desktoptheme mocha-glass >/dev/null && ok "estilo do Plasma: Mocha Glass"
