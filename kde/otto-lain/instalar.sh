#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  otto-lain — o visual "original" do KDE (antes do Catppuccin Mocha)
#
#  ./instalar.sh               instala tudo (faz backup do visual atual antes)
#  ./instalar.sh --sem-backup  não faz backup (não recomendado)
#  ./instalar.sh --so-temas    só copia os temas (você escolhe nas Configurações)
#
#  Para voltar ao visual de antes:  ./voltar.sh
# ---------------------------------------------------------------------------
set -uo pipefail
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/otto-lain"
WALL_DIR="$DATA/wallpapers/otto-lain"
WALL="$WALL_DIR/otto-lain.jpg"

SEM_BACKUP=0 SO_TEMAS=0
for a in "$@"; do
  case "$a" in
    --sem-backup) SEM_BACKUP=1 ;;
    --so-temas) SO_TEMAS=1 ;;
    -h|--help) sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "opção desconhecida: $a" >&2; exit 1 ;;
  esac
done

ok()    { printf '  \e[32m✓\e[0m %s\n' "$*"; }
info()  { printf '  • %s\n' "$*"; }
aviso() { printf '  \e[33m!\e[0m %s\n' "$*" >&2; }
titulo(){ printf '\n\e[1;35m==> %s\e[0m\n' "$*"; }

for c in kwriteconfig6 kreadconfig6 qdbus6 plasma-apply-colorscheme; do
  command -v "$c" >/dev/null || { echo "falta $c (precisa do KDE Plasma 6)" >&2; exit 1; }
done

# --- backup (o mesmo do kde/mocha, para o voltar.sh servir aos dois) ----------
if ((SEM_BACKUP == 0 && SO_TEMAS == 0)); then
  titulo "Backup do visual atual"
  BK="$HOME/kde-backup-$(date +%Y-%m-%d_%H%M%S)"
  "$AQUI/../mocha/backup.sh" "$BK" >/dev/null
  mkdir -p "$HOME/.local/state/kde-mocha-rice"
  echo "$BK" > "$HOME/.local/state/kde-mocha-rice/ultimo-backup"
  ok "salvo em $BK  (para voltar: ./voltar.sh)"
fi

# --- temas -------------------------------------------------------------------
titulo "Temas"
mkdir -p "$DATA"/{plasma/look-and-feel,plasma/desktoptheme,aurorae/themes,color-schemes,icons} "$HOME/.icons" "$WALL_DIR"
cp -a "$AQUI"/temas/look-and-feel/. "$DATA/plasma/look-and-feel/"
cp -a "$AQUI"/temas/desktoptheme/.  "$DATA/plasma/desktoptheme/"
cp -a "$AQUI"/temas/aurorae/.       "$DATA/aurorae/themes/"
cp -a "$AQUI"/temas/color-schemes/. "$DATA/color-schemes/"
cp -a "$AQUI"/temas/cursores/volantes_cursors "$HOME/.icons/"
cp -a "$AQUI"/temas/cursores/volantes_cursors "$DATA/icons/"
cp -a "$AQUI/wallpaper/otto-lain.jpg" "$WALL"
ok "Otto (global + Plasma + decoração), Orchis-dark, MoeDark, splash Lain, cursor Volantes"

# Ícones kora: grandes demais para o repositório, vêm do projeto original
if [[ -d "$DATA/icons/kora" ]]; then
  ok "ícones kora já instalados"
else
  info "baixando ícones kora (github.com/bikass/kora)"
  mkdir -p "$CACHE"; rm -rf "$CACHE"/kora*
  if curl -fL --retry 3 -sS https://codeload.github.com/bikass/kora/tar.gz/HEAD | tar -xz -C "$CACHE" \
     && mv "$CACHE"/kora-* "$CACHE/kora" && cp -a "$CACHE/kora/kora" "$DATA/icons/"; then
    ok "ícones kora"
  else
    aviso "não consegui baixar o kora; instale pela Loja (Configurações › Ícones › Obter novos)"
  fi
fi

if ((SO_TEMAS)); then
  echo; echo "Temas copiados. Escolha-os em Configurações do Sistema › Aparência."; exit 0
fi

# --- configurações -----------------------------------------------------------
titulo "Configurações"
kquitapp6 plasmashell >/dev/null 2>&1 || true
for _ in $(seq 20); do pgrep -x plasmashell >/dev/null || break; sleep 0.3; done
for f in "$AQUI"/config/*; do
  rm -rf "${CFG:?}/$(basename "$f")"; cp -a "$f" "$CFG/"
done
sed -i "s#@WALLPAPER@#$WALL#g" "$CFG/kscreenlockerrc" "$CFG/plasma-org.kde.plasma.desktop-appletsrc"
ok "painéis, atalhos, cores, GTK, Alacritty, btop, Konsole, Dolphin"

# --- aplica ------------------------------------------------------------------
titulo "Aplicando"
plasma-apply-colorscheme BreezeClassic >/dev/null 2>&1
plasma-apply-colorscheme Otto >/dev/null 2>&1 && ok "cores Otto"
plasma-apply-cursortheme volantes_cursors >/dev/null 2>&1 && ok "cursor Volantes"
[[ -x /usr/lib/plasma-changeicons ]] && /usr/lib/plasma-changeicons kora >/dev/null 2>&1 && ok "ícones kora"
qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
pkill -x vicinae >/dev/null 2>&1 || true
(setsid plasmashell >/dev/null 2>&1 &)
sleep 3
plasma-apply-wallpaperimage "$WALL" >/dev/null 2>&1 && ok "wallpaper"

echo
echo "Pronto! Saia e entre de novo na sessão para ver o splash Lain e as fontes em todos os apps."
echo "Voltar ao visual anterior: $AQUI/voltar.sh"
