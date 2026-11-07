#!/usr/bin/env bash
# 50 — Decoração das janelas, cantos arredondados, desfoque e animações
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Janelas e animações"

# --- decoração (barra de título) Catppuccin "Modern" -------------------------
baixar "https://github.com/catppuccin/kde/releases/download/v0.4.0/Modern-Aurorae-Theme.tar.gz" "$CACHE_DIR/aurorae-modern.tar.gz"
mkdir -p "$DATA/aurorae/themes"
tar -xzf "$CACHE_DIR/aurorae-modern.tar.gz" -C "$DATA/aurorae/themes" "Catppuccin${FLAVOR_CAP}-Modern"
DECO="Catppuccin${FLAVOR_CAP}-Modern"
# O pacote de release vem sem o arquivo de medidas (…rc). Sem ele a sombra da
# decoração vira uma borda transparente em volta da janela. Pega do repositório.
baixar "https://codeload.github.com/catppuccin/kde/tar.gz/HEAD" "$CACHE_DIR/cat-kde.tar.gz"
RC="Catppuccin-Modernrc"; [[ $FLAVOR == latte ]] && RC="CatppuccinLatte-Modernrc"
tar -xzf "$CACHE_DIR/cat-kde.tar.gz" -O "kde-HEAD/Resources/Aurorae/Common/$RC" > "$DATA/aurorae/themes/$DECO/${DECO}rc"
# motor Aurorae clássico: o novo (aurorae.v2, Plasma 6.8) não aplicou as medidas
# do tema na hora e deixava a barra de título transparente
kw kwinrc org.kde.kdecoration2 library org.kde.kwin.aurorae
kw kwinrc org.kde.kdecoration2 theme "__aurorae__svg__${DECO}"
kw kwinrc org.kde.kdecoration2 BorderSize None
kw kwinrc org.kde.kdecoration2 BorderSizeAuto false
kw kwinrc org.kde.kdecoration2 ButtonsOnLeft ""
kw kwinrc org.kde.kdecoration2 ButtonsOnRight "IAX"
ok "decoração $DECO (minimizar, maximizar, fechar)"

# --- velocidade das animações ------------------------------------------------
kw kdeglobals KDE AnimationDurationFactor "$VELOCIDADE_ANIMACAO"

# --- efeitos -----------------------------------------------------------------
P=Plugins
kw kwinrc $P blurEnabled true
kw kwinrc $P contrastEnabled true
kw kwinrc $P magiclampEnabled true           # minimizar como "lâmpada mágica"
kw kwinrc $P squashEnabled false
kw kwinrc $P slideEnabled true               # troca de área de trabalho deslizando
kw kwinrc $P fadingpopupsEnabled true
kw kwinrc $P dimscreenEnabled true           # escurece o fundo quando pede senha
kw kwinrc $P wobblywindowsEnabled "$JANELAS_GELATINA"
kw kwinrc $P overviewEnabled true

kw kwinrc Effect-blur BlurStrength 10
kw kwinrc Effect-blur NoiseStrength 4
kw kwinrc Effect-wobblywindows Drag 85
kw kwinrc Effect-wobblywindows Stiffness 10
kw kwinrc Effect-wobblywindows WobblynessLevel 1

# Burn My Windows: animação de abrir/fechar (efeitos em JavaScript, sem sudo)
baixar "https://github.com/Schneegans/Burn-My-Windows/releases/download/v49/burn_my_windows_kwin6.tar.gz" "$CACHE_DIR/bmw-kwin6.tar.gz"
mkdir -p "$DATA/kwin/effects"
tar -xzf "$CACHE_DIR/bmw-kwin6.tar.gz" -C "$DATA/kwin/effects"
for e in glide scale fade "$DATA"/kwin/effects/kwin6_effect_*; do
  kw kwinrc $P "$(basename "$e")Enabled" false
done
kw kwinrc $P "${EFEITO_JANELA}Enabled" true
# Aura Glow no tom do destaque (malva ≈ 0.74 no círculo de cores)
kw kwinrc Effect-kwin6_effect_aura_glow Duration 550
kw kwinrc Effect-kwin6_effect_aura_glow StartHue 0.74
kw kwinrc Effect-kwin6_effect_aura_glow Saturation 0.55
kw kwinrc Effect-kwin6_effect_aura_glow Speed 1.2
kw kwinrc Effect-kwin6_effect_wisps Duration 900
ok "abrir/fechar janelas: $EFEITO_JANELA · minimizar: lâmpada mágica · desfoque ligado"

# --- cantos arredondados + contorno (kwin-effect-rounded-corners) -------------
if ls /usr/lib/qt6/plugins/kwin/effects/plugins/*shapecorners* >/dev/null 2>&1; then
  kw kwinrc $P kwin4_effect_shapecornersEnabled true
  G=Round-Corners
  kw kwinrc $G Size "$RAIO_CANTOS"
  kw kwinrc $G InactiveCornerRadius "$RAIO_CANTOS"
  kw kwinrc $G OutlineThickness 1.5
  kw kwinrc $G InactiveOutlineThickness 1
  kw kwinrc $G ActiveOutlineUsePalette true
  kw kwinrc $G ActiveOutlinePalette 12        # cor de destaque do esquema
  kw kwinrc $G ActiveOutlineAlpha 160
  kw kwinrc $G InactiveOutlineUsePalette true
  kw kwinrc $G InactiveOutlinePalette 3
  kw kwinrc $G InactiveOutlineAlpha 60
  kw kwinrc $G DisableRoundMaximize true
  kw kwinrc $G DisableOutlineMaximize true
  kw kwinrc $G DisableRoundTile false
  ok "cantos arredondados (${RAIO_CANTOS}px) com contorno no destaque"
else
  aviso "efeito de cantos arredondados não instalado (rode o módulo 00)"
fi

# --- áreas de trabalho -------------------------------------------------------
atual=$(qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count 2>/dev/null || echo 0)
for ((i = atual; i < AREAS_DE_TRABALHO; i++)); do
  qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.createDesktop "$i" "$((i + 1))" >/dev/null 2>&1
done
ok "$AREAS_DE_TRABALHO áreas de trabalho (Meta+Ctrl+setas para trocar)"

dbus_kwin_reconfigure
