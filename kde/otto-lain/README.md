# Otto + Lain — o visual anterior do KDE

O visual que eu usava no KDE Plasma 6 antes do [Catppuccin Mocha](../mocha): tons de azul-escuro e roxo,
janelas com a decoração MoeDark e a tela de inicialização da Lain.

| Parte | Tema | Autor / origem | Licença |
|---|---|---|---|
| Tema global e esquema de cores | **Otto** | jomada ([seduccionlinux](https://seduccionlinux.wordpress.com)) | GPL-3.0+ |
| Estilo do Plasma (painéis e popups) | **Orchis-dark** | [vinceliuice/Orchis-kde](https://github.com/vinceliuice/Orchis-kde) | LGPL |
| Decoração das janelas | **MoeDark** (o **Otto** também vem junto) | jomada | GPL-3.0 |
| Tela de inicialização | **Lain** | kloud ([dgudim/themes](https://github.com/dgudim/themes)) | GPL-3.0 |
| Ícones | **kora** | [bikass/kora](https://github.com/bikass/kora) — baixado na instalação | GPL-3.0 |
| Ponteiro do mouse | **Volantes** | [varlesh/volantes-cursors](https://github.com/varlesh/volantes-cursors) | GPL-2.0 |
| Estilo dos aplicativos | Breeze, com animações rápidas (0,25) | KDE | — |

## Instalar

```bash
cd ~/dotfiles/kde/otto-lain
./instalar.sh
```

O instalador:

1. faz um **backup do visual atual** em `~/kde-backup-DATA/` (o mesmo backup do `kde/mocha`);
2. copia os temas para `~/.local/share` e `~/.icons` (sem sudo) e baixa os ícones kora;
3. copia as configurações de `config/` para `~/.config` (painéis, atalhos, cores, GTK, Alacritty, btop, Konsole, Dolphin);
4. aplica cores, cursor, ícones e wallpaper e reinicia o Plasma.

Depois **saia e entre de novo na sessão** para ver o splash Lain.

Só quer os temas, sem mexer nos seus painéis e atalhos?

```bash
./instalar.sh --so-temas
```

e escolha cada um em *Configurações do Sistema › Aparência* (Tema global: Otto; Estilo do Plasma: Orchis-dark;
Decorações: MoeDark; Ícones: kora; Cursores: Volantes; Tela de inicialização: Lain).

## Voltar

```bash
./voltar.sh
```

Volta ao visual que estava antes do último `./instalar.sh` (ou do último `install.sh` do Mocha).

## O que tem aqui

```
otto-lain/
├── instalar.sh     instala (com backup antes)
├── voltar.sh       volta ao visual anterior (usa ../mocha/voltar.sh)
├── temas/          look-and-feel (Otto, Lain), desktoptheme (Otto, Orchis-dark),
│                   aurorae (MoeDark, Otto), color-schemes (Otto), cursores (Volantes)
├── config/         as configurações do KDE desse visual (vão para ~/.config)
└── wallpaper/      o wallpaper
```

O caminho do wallpaper em `config/kscreenlockerrc` e `config/plasma-org.kde.plasma.desktop-appletsrc` está como
`@WALLPAPER@`; o instalador troca pelo caminho certo na sua máquina.

> Os painéis em `config/` foram salvos numa tela 1920×1080. Em outra resolução ou com vários monitores,
> pode ser preciso ajustar o painel na mão (clique direito › Editar modo).
