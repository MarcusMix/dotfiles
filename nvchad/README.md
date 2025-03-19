## Instalação NvChad


### Remove configuração atual da pasta 

```
rm -rf ~/.var/app/io.neovim.nvim/config/nvim
```

### Clonar o repositório dentro da pasta correta
```
git clone https://github.com/MarcusMix/dotfiles ~/.var/app/io.neovim.nvim/config/nvim
```

### Criar alias no bash ou zsh
```
vim ~/.bashrc
alias nvchad='flatpak run io.neovim.nvim'
```

### Atualizar o bash ou zsh
```
source ~/.bashrc
```

### Seja feliz
Após isso, rodando *nvchad* no terminal, irá funcionar.
