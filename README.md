
# Dotfiles

Arquivos de configurações, para facilitar a minha e a sua vida.



## Softwares com configurações

### `Hyprland`
Gerenciador de janelas (TWM) leve e altamente personalizável para Linux, focado em desempenho e estilo. 

Ele oferece suporte a Wayland, auto-tiling e efeitos visuais elegantes. Requer conhecimento técnico para configuração.

### `i3 TWM`
Gerenciador de janelas minimalista que utiliza o conceito de tiling para organizar as janelas. 

Ele é conhecido por sua eficiência e flexibilidade, sendo popular entre usuários que preferem um ambiente de trabalho altamente personalizável.

### `Kitty`
Emulador de terminal moderno e altamente personalizável. 

Ele oferece suporte a OpenGL para renderização rápida e suave, além de recursos como múltiplas guias e janelas.

### `NvChad`
É uma configuração personalizada para o Neovim, focada em tornar o editor de texto mais acessível e visualmente atraente. 

Ele inclui várias funcionalidades e plugins para melhorar a produtividade.

### `Polybar`
Barra de status personalizável que pode ser usada em conjunto com gerenciadores de janelas. 

Ela permite que os usuários exibam informações como CPU, memória, data e hora, além de outros dados personalizados.

Compativel com x11.

### `Waybar`
Barra de status leve e personalizável projetada para o protocolo Wayland. 

Ela oferece suporte a vários módulos para exibir informações como CPU, memória, rede e relógio.

Compativel com Wayland.

### `Picom`
Compositor de janelas que adiciona efeitos visuais como transparência e sombreamento às janelas. 

Ele é frequentemente usado em conjunto com gerenciadores de janelas para melhorar a aparência do desktop.

### `Warp terminal`
Terminal moderno e rápido que oferece recursos como autocompletar, busca instantânea e interface minimalista. 

Ele é projetado para ser altamente personalizável e eficiente.
## Baixar e configurar

Para baixar e configurar os arquivos, abra seu terminal e exercute:

```bash
  git clone https://github.com/MarcusMix/dotfiles
```

#### Entre na pasta

```bash
  cd dotfiles
```

#### Use o GNU/Stow
Escolha qual configuração você quer usar, e use o GNU/Stow para criar links simbólicos para sua config.

Lembrando que você precisa ter o GNU/Stow instalado previamente e que a configuração atual do software esteja vazia.

```bash
  stow hyprland
```


<img src="https://i.imgur.com/tc7aYc4.png" alt="i3 desktop"/>


<img src="https://i.imgur.com/tHNhxgd.png" alt="i3 desktop"/>

- linux mint
- i3
- polybar
- ulauncher
- picom
- nvchad
- warp terminal
