#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up dotfiles...${NC}\n"

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo -e "${GREEN}Oh My Zsh already installed${NC}"
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo -e "${YELLOW}Installing zsh-autosuggestions...${NC}"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo -e "${GREEN}zsh-autosuggestions already installed${NC}"
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo -e "${YELLOW}Installing zsh-syntax-highlighting...${NC}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo -e "${GREEN}zsh-syntax-highlighting already installed${NC}"
fi

# Optional: Install Powerlevel10k theme
# if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
#   echo -e "${YELLOW}Installing Powerlevel10k theme...${NC}"
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# else
#   echo -e "${GREEN}Powerlevel10k already installed${NC}"
# fi

# Create symlinks
echo -e "\n${YELLOW}Creating symlinks...${NC}"

# Backup existing files
backup_if_exists() {
  if [ -f "$1" ] || [ -L "$1" ]; then
    echo -e "${YELLOW}Backing up existing $1 to $1.backup${NC}"
    mv "$1" "$1.backup"
  fi
}

DOTFILES_DIR="$HOME/dotfiles"

# .zshrc
backup_if_exists "$HOME/.zshrc"
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
echo -e "${GREEN}Linked .zshrc${NC}"

# .gitconfig
backup_if_exists "$HOME/.gitconfig"
ln -s "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
echo -e "${GREEN}Linked .gitconfig${NC}"

# .gitignore_global
backup_if_exists "$HOME/.gitignore_global"
ln -s "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
echo -e "${GREEN}Linked .gitignore_global${NC}"

# .config directory
if [ -d "$DOTFILES_DIR/.config" ]; then
  mkdir -p "$HOME/.config"
  for config_dir in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$config_dir" ]; then
      dir_name=$(basename "$config_dir")
      backup_if_exists "$HOME/.config/$dir_name"
      ln -s "$config_dir" "$HOME/.config/$dir_name"
      echo -e "${GREEN}Linked .config/$dir_name${NC}"
    fi
  done
fi

echo -e "\n${GREEN}✓ Dotfiles setup complete!${NC}"
echo -e "${YELLOW}Please restart your terminal or run: source ~/.zshrc${NC}\n"
