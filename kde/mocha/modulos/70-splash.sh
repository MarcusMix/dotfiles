#!/usr/bin/env bash
# 70 — Tela de inicialização (splash do KDE, aparece depois do login)
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Tela de inicialização"

DEST="$DATA/plasma/look-and-feel/kde-mocha-rice"
rm -rf "$DEST" && mkdir -p "$(dirname "$DEST")"
cp -r "$RICE_DIR/assets/splash/kde-mocha-rice" "$DEST"
cp "$RICE_DIR/assets/wallpapers/$WALLPAPER" "$DEST/contents/splash/images/fundo.jpg"
kw ksplashrc KSplash Theme kde-mocha-rice
kw ksplashrc KSplash Engine KSplashQML
ok "splash animado (teste agora: ksplashqml kde-mocha-rice --test)"
