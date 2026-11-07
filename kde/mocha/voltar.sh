#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  voltar.sh — volta ao visual que você tinha antes de instalar o rice
#
#  ./voltar.sh                  usa o backup feito pelo último ./install.sh
#  ./voltar.sh ~/kde-backup-X   usa um backup específico
# ---------------------------------------------------------------------------
set -euo pipefail

if [[ $# -ge 1 ]]; then
  BK="$1"
elif [[ -f "$HOME/.local/state/kde-mocha-rice/ultimo-backup" ]]; then
  BK="$(cat "$HOME/.local/state/kde-mocha-rice/ultimo-backup")"
else
  BK="$(ls -d "$HOME"/kde-backup-* 2>/dev/null | sort | tail -1 || true)"
fi

if [[ -z "${BK:-}" || ! -x "$BK/restaurar.sh" ]]; then
  echo "Não achei um backup. Passe a pasta: ./voltar.sh ~/kde-backup-AAAA-MM-DD_HHMMSS" >&2
  echo "Backups encontrados:" >&2; ls -d "$HOME"/kde-backup-* 2>/dev/null >&2 || echo "  (nenhum)" >&2
  exit 1
fi

read -rp "Voltar ao visual salvo em $BK ? [s/N] " r
[[ "$r" =~ ^[sSyY] ]] || { echo "Nada mudou."; exit 0; }
exec "$BK/restaurar.sh"
