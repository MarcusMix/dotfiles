#!/usr/bin/env bash
# 00 — Pacotes do sistema (o ÚNICO passo que pede senha de administrador)
#   kvantum                      -> motor de tema dos aplicativos Qt (estilo dos apps)
#   kwin-effect-rounded-corners  -> cantos arredondados + contorno nas janelas
# Tudo o mais (fontes, ícones, cursor, sons, lançador, prompt) é instalado no seu
# usuário, sem sudo.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comum.sh"
titulo "Pacotes do sistema"

if ! tem pacman; then
  aviso "Não é Arch/CachyOS. Instale pelo gerenciador da sua distro: kvantum e kwin-effect-rounded-corners (opcional)."
  exit 0
fi

faltando=()
for p in kvantum kwin-effect-rounded-corners; do
  pacman -Qq "$p" >/dev/null 2>&1 || pacman -Qq "${p}-git" >/dev/null 2>&1 || faltando+=("$p")
done
if ((${#faltando[@]} == 0)); then ok "tudo já instalado"; exit 0; fi

# kwin-effect-rounded-corners está no repositório do CachyOS; no Arch puro vem do AUR
repo=() aur=()
for p in "${faltando[@]}"; do
  if pacman -Si "$p" >/dev/null 2>&1; then repo+=("$p"); else aur+=("$p"); fi
done

if ((${#repo[@]})); then
  info "vou rodar: sudo pacman -S --needed ${repo[*]}"
  sudo pacman -S --needed --noconfirm "${repo[@]}" || aviso "pacman falhou — o resto do rice segue sem esses pacotes"
fi
if ((${#aur[@]})); then
  if tem paru; then paru -S --needed --noconfirm kwin-effect-rounded-corners-git
  elif tem yay; then yay -S --needed --noconfirm kwin-effect-rounded-corners-git
  else aviso "instale do AUR depois: kwin-effect-rounded-corners-git (cantos arredondados)"; fi
fi
ok "pacotes conferidos"
