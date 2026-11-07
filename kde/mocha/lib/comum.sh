# shellcheck shell=bash
# Funções compartilhadas por todos os scripts do rice.
# Este arquivo é carregado com `source`, nunca executado sozinho.

RICE_DIR="${RICE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/kde-mocha-rice"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
BIN="$HOME/.local/bin"
mkdir -p "$CACHE_DIR" "$BIN" "$DATA"

# Configurações do usuário (sabor, cor de destaque, fontes...)
# shellcheck source=../rice.conf
source "$RICE_DIR/rice.conf"

# --- saída bonita ----------------------------------------------------------
if [[ -t 1 ]]; then
  C_M=$'\e[38;2;203;166;247m' C_G=$'\e[38;2;166;227;161m' C_Y=$'\e[38;2;249;226;175m'
  C_R=$'\e[38;2;243;139;168m' C_D=$'\e[38;2;127;132;156m' C_0=$'\e[0m' C_B=$'\e[1m'
else
  C_M="" C_G="" C_Y="" C_R="" C_D="" C_0="" C_B=""
fi
titulo() { printf '\n%s%s==> %s%s\n' "$C_B" "$C_M" "$*" "$C_0"; }
info()   { printf '  %s•%s %s\n' "$C_D" "$C_0" "$*"; }
ok()     { printf '  %s✓%s %s\n' "$C_G" "$C_0" "$*"; }
aviso()  { printf '  %s!%s %s\n' "$C_Y" "$C_0" "$*" >&2; }
erro()   { printf '  %s✗%s %s\n' "$C_R" "$C_0" "$*" >&2; }

tem() { command -v "$1" >/dev/null 2>&1; }

# kw ARQUIVO GRUPO[/SUBGRUPO...] CHAVE VALOR
# Ex.: kw kdeglobals "KDE" AnimationDurationFactor 0.7
#      kw kwinrc "Effect-blur" BlurStrength 8
kw() {
  local arquivo=$1 grupos=$2 chave=$3 valor=$4 args=()
  local IFS='/'
  for g in $grupos; do args+=(--group "$g"); done
  kwriteconfig6 --file "$arquivo" "${args[@]}" --key "$chave" -- "$valor"
}
kr() {
  local arquivo=$1 grupos=$2 chave=$3 args=()
  local IFS='/'
  for g in $grupos; do args+=(--group "$g"); done
  kreadconfig6 --file "$arquivo" "${args[@]}" --key "$chave"
}

# baixar URL DESTINO — baixa para o cache só uma vez
baixar() {
  local url=$1 destino=$2
  if [[ -s "$destino" ]]; then return 0; fi
  info "baixando $(basename "$destino")"
  curl -fL --retry 3 --connect-timeout 15 -sS -o "$destino.part" "$url" && mv "$destino.part" "$destino"
}

# github_tarball dono/repo DESTINO_DIR — baixa o código do branch padrão e extrai
github_tarball() {
  local repo=$1 destino=$2 arq
  arq="$CACHE_DIR/$(echo "$repo" | tr '/' '_').tar.gz"
  baixar "https://codeload.github.com/$repo/tar.gz/HEAD" "$arq" || return 1
  rm -rf "$destino" && mkdir -p "$destino"
  tar -xzf "$arq" -C "$destino" --strip-components=1
}

# Nome capitalizado do sabor/destaque (mocha -> Mocha)
cap() { local s=$1; printf '%s%s' "${s:0:1}" | tr '[:lower:]' '[:upper:]'; printf '%s' "${s:1}"; }
FLAVOR_CAP=$(cap "$FLAVOR")
ACCENT_CAP=$(cap "$ACCENT")

dbus_kwin_reconfigure() { qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true; }
