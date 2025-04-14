# 🚀 Dotfiles

![GitHub stars](https://img.shields.io/github/stars/MarcusMix/dotfiles?style=social)
![GitHub forks](https://img.shields.io/github/forks/MarcusMix/dotfiles?style=social)
![GitHub license](https://img.shields.io/github/license/MarcusMix/dotfiles?style=flat-square)

> Minha coleção pessoal de arquivos de configuração para criar o ambiente de desenvolvimento perfeito. Projetados para maximizar a produtividade e proporcionar uma experiência visual incrível.

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
