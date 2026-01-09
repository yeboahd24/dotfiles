# My Dotfiles

Personal configuration files for development environment.

## Quick Setup
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## What's Included

- `.zshrc` - Oh My Zsh configuration with plugins
- `.gitconfig` - Git configuration with aliases
- `.gitignore_global` - Global gitignore patterns
- `.config/nvim/` - Neovim configuration

## Manual Installation

If you prefer manual setup:

1. Install Oh My Zsh:
```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. Install plugins:
```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

3. Create symlinks:
```bash
   ln -s ~/dotfiles/.zshrc ~/.zshrc
   ln -s ~/dotfiles/.gitconfig ~/.gitconfig
   ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
```

4. Reload shell:
```bash
   source ~/.zshrc
```
