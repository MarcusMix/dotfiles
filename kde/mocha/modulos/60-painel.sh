#!/usr/bin/env bash
# 60 — Taskbar: barra fina no topo + dock flutuante embaixo
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Painéis (taskbar)"

if [[ "$PAINEL" != "topo+dock" ]]; then info "PAINEL=$PAINEL em rice.conf — não mexo nos painéis"; exit 0; fi

# Ícone do menu: logo do rice (lua crescente na cor de destaque)
mkdir -p "$DATA/icons/hicolor/scalable/apps"
cp "$RICE_DIR/assets/icones/mocharicemenu.svg" "$DATA/icons/hicolor/scalable/apps/"
gtk-update-icon-cache -q -f "$DATA/icons/hicolor" 2>/dev/null || true

# Só fixa na dock os apps que existem nesta máquina
apps=()
IFS=',' read -ra lista <<<"$DOCK_APPS"
for a in "${lista[@]}"; do
  for d in "$DATA/applications" /usr/share/applications /var/lib/flatpak/exports/share/applications "$DATA/flatpak/exports/share/applications"; do
    if [[ -f "$d/$a" ]]; then apps+=("$a"); break; fi
  done
done
DOCK=$(IFS=','; echo "${apps[*]}")

script="var DOCK_APPS = \"$DOCK\";
$(cat "$RICE_DIR/config/plasma/painel.js")"
if qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$script" >/dev/null; then
  ok "barra no topo + dock com: ${DOCK//,/, }"
else
  erro "o Plasma recusou o script do painel"
fi
