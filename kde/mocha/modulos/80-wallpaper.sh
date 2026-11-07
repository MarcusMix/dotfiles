#!/usr/bin/env bash
# 80 — Wallpaper da área de trabalho e da tela de bloqueio
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Wallpaper"

DEST="$DATA/wallpapers/kde-mocha-rice"
mkdir -p "$DEST"
cp "$RICE_DIR"/assets/wallpapers/* "$DEST/"

plasma-apply-wallpaperimage "$DEST/$WALLPAPER" >/dev/null && ok "área de trabalho: $WALLPAPER"

G="Greeter/Wallpaper/org.kde.image/General"
kw kscreenlockerrc "$G" Image "file://$DEST/$WALLPAPER_BLOQUEIO"
kw kscreenlockerrc "$G" PreviewImage "file://$DEST/$WALLPAPER_BLOQUEIO"
kw kscreenlockerrc Greeter WallpaperPlugin org.kde.image
ok "tela de bloqueio: $WALLPAPER_BLOQUEIO"
info "todos os wallpapers ficam em $DEST (clique direito na área de trabalho para trocar)"
