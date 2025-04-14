# 🚀 Dotfiles

![GitHub stars](https://img.shields.io/github/stars/MarcusMix/dotfiles?style=social)
![GitHub forks](https://img.shields.io/github/forks/MarcusMix/dotfiles?style=social)
![GitHub license](https://img.shields.io/github/license/MarcusMix/dotfiles?style=flat-square)

> Meus arquivos de configurações 🎃

<div align="center">
  <img src="https://i.imgur.com/tc7aYc4.png" alt="Desktop Screenshot" width="800px"/>
</div>

## 📋 Conteúdo

- [Visão Geral](#-visão-geral)
- [Previews](#-previews)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Configurações Disponíveis](#-configurações-disponíveis)
- [Personalização](#-personalização)
- [Atalhos de Teclado](#-atalhos-de-teclado)
- [Temas](#-temas)
- [Perguntas Frequentes](#-perguntas-frequentes)
- [Contribuições](#-contribuições)
- [Licença](#-licença)

## 🔍 Visão Geral

Esta coleção de dotfiles foi criada para proporcionar um ambiente de desenvolvimento Linux elegante, eficiente e altamente produtivo. Configurações cuidadosamente ajustadas para gerenciadores de janelas, terminais, editores e muito mais!

**Ambiente atual:**
- Sistema: Linux Mint
- WM: i3/Hyprland
- Terminal: Kitty/Warp
- Editor: Neovim (NvChad)
- Status Bar: Polybar/Waybar
- Lançador: ULauncher
- Compositor: Picom

## 👀 Previews

<details>
<summary>🖥️ Desktop i3 (Clique para expandir)</summary>
<div align="center">
  <img src="https://i.imgur.com/tc7aYc4.png" alt="i3 Desktop Screenshot" width="800px"/>
  <img src="https://i.imgur.com/tHNhxgd.png" alt="i3 Desktop Screenshot 2" width="800px"/>
</div>
</details>

<details>
<summary>🖥️ Desktop Hyprland (Clique para expandir)</summary>
<div align="center">
  <p>Capturas de tela serão adicionadas em breve!</p>
</div>
</details>

<details>
<summary>📝 NvChad (Clique para expandir)</summary>
<div align="center">
  <p>Capturas de tela serão adicionadas em breve!</p>
</div>
</details>

## 📦 Requisitos

- Linux (testado em Linux Mint, mas deve funcionar em qualquer distribuição)
- Git
- [GNU Stow](https://www.gnu.org/software/stow/) para gerenciar links simbólicos
- Aplicativos específicos para cada configuração (listados abaixo)

## 💻 Instalação

1. Clone este repositório:
```bash
git clone https://github.com/MarcusMix/dotfiles
```

2. Entre na pasta:
```bash
  cd dotfiles
```

3. Use o GNU Stow para criar links simbólicos para a configuração desejada:
```bash
stow hyprland   # Para configuração do Hyprland
# OU
stow i3         # Para configuração do i3
# OU qualquer outra configuração disponível
```

> **⚠️ Importante**: Certifique-se de que não existem arquivos de configuração conflitantes antes de usar o Stow. Recomenda-se fazer backup das configurações existentes.

## 🛠️ Configurações Disponíveis

### Gerenciadores de Janelas

### `Hyprland`

Um gerenciador de janelas tiling moderno para Wayland, focado em animações fluidas e desempenho.
- Instalação:
- sudo ```bash pacman -S hyprland ``` (Arch) ou consulte a documentação oficial
- Dependências: waybar, rofi-wayland, kitty

### `i3`

Gerenciador de janelas tiling minimalista e altamente configurável para X11.
- Instalação: ```bash sudo apt install i3 ```  ou equivalente
- Dependências: polybar, picom, kitty/warp

###  Terminais

### `Kitty`

Terminal GPU-acelerado com rico conjunto de recursos.
- Instalação: ```bash sudo apt install kitty ```  ou equivalente
- Recursos: múltiplas guias, divisão de janelas, suporte a imagens

### `Warp Terminal`
Terminal moderno com recursos inteligentes de autocomplete e interface limpa.
- Instalação: Baixe em [warp.dev](https://www.warp.dev/)
- Recursos: comando natural, pesquisa inteligente, temas

### Editores

### `NvChad`
Configuração elegante e rápida para Neovim com diversos plugins úteis.
- Instalação via dotfiles ou seguindo instruções em [NvChad](https://nvchad.com/)
- Recursos: LSP, treesitter, telescope, harpoon

### Barras de Status

### `Polybar` (para X11)
Barra de status altamente configurável com dezenas de módulos.
- Instalação: ```bash sudo apt install polybar``` ou equivalente

### `Waybar` (para Wayland)
Barra moderna e elegante para ambientes Wayland.
- Instalação: ```bash sudo apt install waybar``` ou equivalente

### Compositores

### `Picom`
Compositor para X11 com efeitos visuais como transparência e sombras.
- Instalação: ```bash sudo apt install picom``` ou equivalente

## 🎨 Personalização

Os dotfiles foram projetados para serem facilmente personalizáveis:

- **Cores e Temas**: Edite os arquivos de configuração para alterar esquemas de cores
- **Fontes**: A configuração usa fonts Nerd ou JetBrains Mono por padrão
- **Ícones**: Compatível com diversos pacotes de ícones
- **Comportamentos**: Ajuste atalhos de teclado e comportamentos nos respectivos arquivos de configuração

## ⌨️ Atalhos de Teclado

<details>
<summary>Atalhos do i3 (Clique para expandir)</summary>

| Atalho | Ação |
|--------|------|
| `Super + Enter` | Abrir terminal |
| `Super + Space` | Abrir menu de aplicativos |
| `Super + Q` | Fechar janela atual |
| `Super + 1-9` | Alternar entre workspaces |
| `Super + Shift + 1-9` | Mover janela para workspace |
| `Super + R` | Modo de redimensionamento |
| `Super + H/J/K/L` | Navegação entre janelas (estilo Vim) |
| `Super + ⬆️⬇️⬅️➡️` | Navegação entre janelas |
| `Super + Shift + E` | Sair do i3 |

</details>

<details>
<summary>Atalhos do Hyprland (Clique para expandir)</summary>

| Atalho | Ação |
|--------|------|
| `Super + Enter` | Abrir terminal |
| `Super + D` | Abrir menu de aplicativos |
| `Super + Q` | Fechar janela atual |
| `Super + 1-9` | Alternar entre workspaces |
| `Super + Shift + 1-9` | Mover janela para workspace |
| `Super + F` | Alternar modo fullscreen |
| `Super + Mouse` | Mover janelas flutuantes |

</details>

## 🎭 Temas

A configuração atual inclui temas integrados que podem ser facilmente alternados. Edite os respectivos arquivos de configuração para mudar o tema:

- **Terminal**: Configurações de cores em `~/.config/kitty/theme.conf`
- **Neovim**: Temas em `~/.config/nvim/lua/custom/chadrc.lua`
- **WM**: Cores em `~/.config/i3/config` ou `~/.config/hypr/hyprland.conf`

## ❓ Perguntas Frequentes

<details>
<summary>Como faço para instalar apenas um componente específico?</summary>
Use o GNU Stow para o componente específico, por exemplo: `stow nvim` para instalar apenas a configuração do Neovim.
</details>

<details>
<summary>O que fazer se algo não funcionar?</summary>
Verifique os logs, as dependências necessárias e se há conflitos com configurações existentes. Sinta-se à vontade para abrir uma issue no repositório.
</details>

<details>
<summary>Posso usar essas configurações no MacOS ou Windows?</summary>
Algumas configurações como Neovim, Kitty e Warp funcionam em múltiplas plataformas. As configurações de WM são específicas para Linux.
</details>

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do repositório
2. Criar uma branch com sua feature: `git checkout -b minha-feature`
3. Commit suas mudanças: `git commit -m 'Adicionando uma feature incrível'`
4. Push para a branch: `git push origin minha-feature`
5. Abrir um Pull Request

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

<div align="center">
  <p>Feito com ❤️ por <a href="https://github.com/MarcusMix">MarcusMix</a></p>
  <p>Inspirado por várias configurações incríveis da comunidade Linux</p>
  <p>⭐ Este repositório se for útil para você!</p>
</div>
