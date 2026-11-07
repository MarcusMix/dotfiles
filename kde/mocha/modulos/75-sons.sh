#!/usr/bin/env bash
# 75 — Sons do sistema: tema "Ocean" do KDE (suave, gravado com instrumentos reais)
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Sons do sistema"

if [[ ! -f /usr/share/sounds/ocean/index.theme && ! -f "$DATA/sounds/ocean/index.theme" ]]; then
  VER=6.8.2
  baixar "https://download.kde.org/stable/plasma/$VER/ocean-sound-theme-$VER.tar.xz" "$CACHE_DIR/ocean.tar.xz"
  mkdir -p "$DATA/sounds"
  tar -xJf "$CACHE_DIR/ocean.tar.xz" -C "$DATA/sounds" --strip-components=1 "ocean-sound-theme-$VER/ocean"
fi
kw kdeglobals Sounds Theme ocean
kw kdeglobals Sounds Enable true
# som de "plim" ao mudar o volume
kw plasmaparc General VolumeFeedback true
for v in gtk-3.0 gtk-4.0; do
  kw "$CFG/$v/settings.ini" Settings gtk-sound-theme-name ocean
  kw "$CFG/$v/settings.ini" Settings gtk-enable-event-sounds true
done
ok "tema de sons Ocean (login, notificações, volume, bateria...)"
