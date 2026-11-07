#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  kde-mocha-rice — instalador
#
#  ./install.sh                 instala tudo (faz backup do visual atual antes)
#  ./install.sh --sem-sudo      pula os pacotes do sistema (sem pedir senha)
#  ./install.sh --so 50 85      roda só alguns módulos (pelo número)
#  ./install.sh --lista         mostra os módulos
#  ./install.sh --sem-backup    não faz backup (não recomendado)
#
#  Para voltar ao visual de antes:  ./voltar.sh
# ---------------------------------------------------------------------------
set -uo pipefail
RICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export RICE_DIR
source "$RICE_DIR/lib/comum.sh"

SEM_SUDO=0 SEM_BACKUP=0 SO=()
while (($#)); do
  case "$1" in
    --sem-sudo) SEM_SUDO=1 ;;
    --sem-backup) SEM_BACKUP=1 ;;
    --so) shift; while (($#)) && [[ "$1" != --* ]]; do SO+=("$1"); shift; done; continue ;;
    --lista)
      for m in "$RICE_DIR"/modulos/*.sh; do printf '  %s  %s\n' "$(basename "$m" .sh)" "$(sed -n '2p' "$m" | sed 's/^# [0-9]* — //')"; done
      exit 0 ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) erro "opção desconhecida: $1"; exit 1 ;;
  esac
  shift
done

printf '%s' "$C_M"
cat <<'ARTE'

   ╭──────────────────────────────────────────────╮
   │   ☾  kde-mocha-rice · Catppuccin para o KDE  │
   ╰──────────────────────────────────────────────╯
ARTE
printf '%s' "$C_0"
info "sabor: $FLAVOR · destaque: $ACCENT · fontes: $FONTE_INTERFACE / $FONTE_MONO"

# --- conferências ------------------------------------------------------------
falta=()
for c in kwriteconfig6 kreadconfig6 qdbus6 plasma-apply-colorscheme curl tar unzip busctl; do tem "$c" || falta+=("$c"); done
if ((${#falta[@]})); then erro "faltam programas: ${falta[*]} (precisa do KDE Plasma 6)"; exit 1; fi
if [[ "${XDG_CURRENT_DESKTOP:-}" != *KDE* ]]; then
  aviso "você não está numa sessão KDE agora; algumas partes só valem depois de entrar no Plasma"
fi

# --- backup ------------------------------------------------------------------
if ((SEM_BACKUP == 0)) && ((${#SO[@]} == 0)); then
  titulo "Backup do visual atual"
  BK="$HOME/kde-backup-$(date +%Y-%m-%d_%H%M%S)"
  "$RICE_DIR/backup.sh" "$BK" >/dev/null
  mkdir -p "$HOME/.local/state/kde-mocha-rice"
  echo "$BK" > "$HOME/.local/state/kde-mocha-rice/ultimo-backup"
  ok "salvo em $BK  (para voltar: ./voltar.sh)"
fi

# --- módulos -----------------------------------------------------------------
falhas=()
for m in "$RICE_DIR"/modulos/*.sh; do
  n=$(basename "$m"); n=${n%%-*}
  if ((${#SO[@]})) && [[ ! " ${SO[*]} " == *" $n "* ]]; then continue; fi
  if [[ "$n" == 00 ]] && ((SEM_SUDO)); then info "pulando pacotes do sistema (--sem-sudo)"; continue; fi
  bash "$m" || falhas+=("$(basename "$m")")
done

# --- recarrega ---------------------------------------------------------------
titulo "Aplicando"
dbus_kwin_reconfigure
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell >/dev/null 2>&1 || true
ok "KWin e Plasma recarregados"

echo
if ((${#falhas[@]})); then aviso "módulos com erro: ${falhas[*]} — rode de novo com: ./install.sh --so <número>"; fi
printf '%s%s  Pronto! %s\n' "$C_B" "$C_G" "$C_0"
cat <<FIM
  • Meta+Espaço abre o lançador Vicinae
  • Saia e entre de novo na sessão para ver a tela de inicialização
    e para todos os apps pegarem as fontes novas
  • Voltar ao visual anterior: $RICE_DIR/voltar.sh
FIM
