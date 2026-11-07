#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  backup.sh — salva o visual ATUAL do KDE e cria um restaurar.sh
#
#  Uso:   ./backup.sh                 (salva em ~/kde-backup-AAAA-MM-DD_HHMM)
#         ./backup.sh ~/meu-backup    (salva onde você quiser)
#
#  Para voltar ao visual salvo:   ~/kde-backup-.../restaurar.sh
# ---------------------------------------------------------------------------
set -euo pipefail

DESTINO="${1:-$HOME/kde-backup-$(date +%Y-%m-%d_%H%M)}"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

# Tudo o que o rice pode alterar (relativo a ~/.config e ~/.local/share)
ITENS_CONFIG=(
  kdeglobals kwinrc kwinrulesrc plasmarc plasmashellrc
  plasma-org.kde.plasma.desktop-appletsrc ksplashrc kcminputrc kscreenlockerrc
  kglobalshortcutsrc krunnerrc konsolerc dolphinrc plasmanotifyrc kdedefaults
  breezerc auroraerc kcmfonts klassyrc plasmaparc
  gtk-3.0 gtk-4.0 gtkrc gtkrc-2.0 xsettingsd Kvantum
  alacritty fish starship.toml fastfetch btop vicinae autostart
)
ITENS_DATA=( konsole applications/kde-mocha-rice-vicinae.desktop )
ITENS_HOME=( .bashrc .zshrc .icons/default )

if [[ -e "$DESTINO" ]]; then
  echo "Já existe: $DESTINO — escolha outro nome." >&2; exit 1
fi
mkdir -p "$DESTINO/config" "$DESTINO/data" "$DESTINO/home" "$DESTINO/wallpapers"
: > "$DESTINO/ausentes.txt"

for item in "${ITENS_CONFIG[@]}"; do
  if [[ -e "$CFG/$item" ]]; then cp -a "$CFG/$item" "$DESTINO/config/"
  else echo "config/$item" >> "$DESTINO/ausentes.txt"; fi
done
for item in "${ITENS_DATA[@]}"; do
  if [[ -e "$DATA/$item" ]]; then
    mkdir -p "$DESTINO/data/$(dirname "$item")"; cp -a "$DATA/$item" "$DESTINO/data/$item"
  else echo "data/$item" >> "$DESTINO/ausentes.txt"; fi
done
for item in "${ITENS_HOME[@]}"; do
  if [[ -e "$HOME/$item" ]]; then
    mkdir -p "$DESTINO/home/$(dirname "$item")"; cp -a "$HOME/$item" "$DESTINO/home/$item"
  else echo "home/$item" >> "$DESTINO/ausentes.txt"; fi
done

# Guarda também as imagens de wallpaper em uso (caso o arquivo original suma)
: > "$DESTINO/wallpapers/mapa.txt"
grep -hoE '^(Image|PreviewImage)=.*' \
  "$CFG/plasma-org.kde.plasma.desktop-appletsrc" "$CFG/kscreenlockerrc" 2>/dev/null \
  | cut -d= -f2- | sed 's#^file://##' | sort -u | while read -r img; do
    if [[ -f "$img" ]]; then
      nome="$(md5sum <<<"$img" | cut -c1-8)-$(basename "$img")"
      cp -a "$img" "$DESTINO/wallpapers/$nome"
      printf '%s\t%s\n' "$nome" "$img" >> "$DESTINO/wallpapers/mapa.txt"
    fi
  done

# Resumo legível do que estava em uso
{
  echo "Backup do visual do KDE — $(date '+%d/%m/%Y %H:%M')"
  echo "Tema global:      $(kreadconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage)"
  echo "Esquema de cores: $(kreadconfig6 --file kdeglobals --group General --key ColorScheme)"
  echo "Ícones:           $(kreadconfig6 --file kdeglobals --group Icons --key Theme)"
  echo "Estilo apps:      $(kreadconfig6 --file kdeglobals --group KDE --key widgetStyle)"
  echo "Estilo Plasma:    $(kreadconfig6 --file plasmarc --group Theme --key name)"
  echo "Cursor:           $(kreadconfig6 --file kcminputrc --group Mouse --key cursorTheme)"
  echo "Decoração:        $(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme)"
  echo "Splash:           $(kreadconfig6 --file ksplashrc --group KSplash --key Theme)"
  echo "Sons:             $(kreadconfig6 --file kdeglobals --group Sounds --key Theme)"
  echo "Fonte:            $(kreadconfig6 --file kdeglobals --group General --key font)"
} > "$DESTINO/LEIA-ME.txt"

cat > "$DESTINO/restaurar.sh" <<'RESTAURAR'
#!/usr/bin/env bash
# Restaura o visual do KDE salvo nesta pasta. Uso: ./restaurar.sh
set -uo pipefail
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "==> Restaurando o visual salvo em $AQUI"
cat "$AQUI/LEIA-ME.txt"; echo

# 1. Para o Plasma para ele não regravar os arquivos enquanto copiamos
kquitapp6 plasmashell >/dev/null 2>&1 || true
for _ in $(seq 20); do pgrep -x plasmashell >/dev/null || break; sleep 0.3; done

# 2. Remove o que não existia antes e devolve os arquivos salvos
while read -r item; do
  [[ -z "$item" ]] && continue
  case "$item" in
    config/*) rm -rf "${CFG:?}/${item#config/}" ;;
    data/*)   rm -rf "${DATA:?}/${item#data/}" ;;
    home/*)   rm -rf "${HOME:?}/${item#home/}" ;;
  esac
done < "$AQUI/ausentes.txt"
for f in "$AQUI"/config/* "$AQUI"/config/.[!.]*; do
  [[ -e "$f" ]] || continue
  rm -rf "${CFG:?}/$(basename "$f")"; cp -a "$f" "$CFG/"
done
if [[ -d "$AQUI/data" ]]; then cp -a "$AQUI/data/." "$DATA/"; fi
if [[ -d "$AQUI/home" ]]; then cp -a "$AQUI/home/." "$HOME/"; fi

# 3. Wallpapers que sumiram voltam para o lugar
while IFS=$'\t' read -r nome original; do
  [[ -z "$nome" ]] && continue
  if [[ ! -f "$original" ]]; then mkdir -p "$(dirname "$original")"; cp -a "$AQUI/wallpapers/$nome" "$original"; fi
done < "$AQUI/wallpapers/mapa.txt"

# 4. Reaplica cores, cursor e ícones (avisa os apps abertos)
esquema=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme)
if [[ -n "$esquema" ]]; then
  plasma-apply-colorscheme BreezeClassic >/dev/null 2>&1
  plasma-apply-colorscheme "$esquema" >/dev/null 2>&1
fi
cursor=$(kreadconfig6 --file kcminputrc --group Mouse --key cursorTheme)
[[ -n "$cursor" ]] && plasma-apply-cursortheme "$cursor" >/dev/null 2>&1
icones=$(kreadconfig6 --file kdeglobals --group Icons --key Theme)
[[ -n "$icones" && -x /usr/lib/plasma-changeicons ]] && /usr/lib/plasma-changeicons "$icones" >/dev/null 2>&1
qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true

# 5. Lançador Vicinae do rice (se estiver rodando)
pkill -x vicinae >/dev/null 2>&1 || true

# 6. Sobe o Plasma de novo
(setsid plasmashell >/dev/null 2>&1 &)
echo
echo "Pronto! Para tudo voltar 100% (fontes nos apps, atalhos, splash), saia e entre de novo na sessão."
RESTAURAR
chmod +x "$DESTINO/restaurar.sh"

echo "Visual atual salvo em: $DESTINO"
echo "Para voltar a ele depois:  $DESTINO/restaurar.sh"
