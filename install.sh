#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up dotfiles...${NC}\n"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
fi

# Check Neovim version
check_nvim_version() {
  if command -v nvim &> /dev/null; then
    version=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+')
    echo "$version"
  else
    echo "none"
  fi
}

# Compare versions
version_ge() {
  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# Install Neovim (latest version)
install_neovim() {
  echo -e "${BLUE}Installing latest Neovim...${NC}"
  
  if [ "$OS" == "linux" ]; then
    echo -e "${YELLOW}Downloading Neovim latest release...${NC}"
    cd /tmp
    
    # Download the latest stable release
    if ! curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; then
      echo -e "${RED}Failed to download Neovim${NC}"
      exit 1
    fi
    
    echo -e "${YELLOW}Installing to /opt/nvim-linux-x86_64...${NC}"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    
    # Temporary export for current session
    export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
    
    rm /tmp/nvim-linux-x86_64.tar.gz
    
    # Verify installation
    if command -v nvim &> /dev/null; then
      nvim_version=$(check_nvim_version)
      echo -e "${GREEN}✓ Neovim $nvim_version installed to /opt/nvim-linux-x86_64${NC}"
    else
      echo -e "${RED}✗ Neovim installation failed${NC}"
      exit 1
    fi
    
  elif [ "$OS" == "macos" ]; then
    if ! command -v brew &> /dev/null; then
      echo -e "${YELLOW}Installing Homebrew...${NC}"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo -e "${YELLOW}Using Homebrew to install Neovim...${NC}"
    brew install neovim
    nvim_version=$(check_nvim_version)
    echo -e "${GREEN}✓ Neovim $nvim_version installed via Homebrew${NC}"
  fi
}

# Install system packages
install_packages() {
  echo -e "${BLUE}Installing system packages...${NC}"
  
  if [ "$OS" == "linux" ]; then
    if command -v apt-get &> /dev/null; then
      echo -e "${YELLOW}Using apt-get...${NC}"
      sudo apt-get update
      sudo apt-get install -y tmux git curl zsh build-essential
    elif command -v dnf &> /dev/null; then
      echo -e "${YELLOW}Using dnf...${NC}"
      sudo dnf install -y tmux git curl zsh gcc make
    elif command -v pacman &> /dev/null; then
      echo -e "${YELLOW}Using pacman...${NC}"
      sudo pacman -S --noconfirm tmux git curl zsh base-devel
    else
      echo -e "${RED}Package manager not detected. Please install tmux, git, curl, and zsh manually.${NC}"
    fi
  elif [ "$OS" == "macos" ]; then
    if ! command -v brew &> /dev/null; then
      echo -e "${YELLOW}Installing Homebrew...${NC}"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo -e "${YELLOW}Using Homebrew...${NC}"
    brew install tmux git curl zsh
  fi
  
  echo -e "${GREEN}✓ System packages installed${NC}\n"
}

# Install packages if needed
if ! command -v tmux &> /dev/null; then
  install_packages
else
  echo -e "${GREEN}tmux already installed${NC}\n"
fi

# Check and install Neovim
current_version=$(check_nvim_version)
required_version="0.11.2"

if [ "$current_version" == "none" ]; then
  echo -e "${YELLOW}Neovim not found. Installing...${NC}"
  install_neovim
elif version_ge "$current_version" "$required_version"; then
  echo -e "${GREEN}Neovim $current_version is already installed (>= $required_version required)${NC}"
else
  echo -e "${YELLOW}Neovim $current_version is installed but LazyVim requires >= $required_version${NC}"
  read -p "Do you want to upgrade to the latest version? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_neovim
  else
    echo -e "${RED}Warning: LazyVim may not work properly with Neovim $current_version${NC}"
  fi
fi

echo ""

# Change default shell to zsh if not already
if [ "$SHELL" != "$(which zsh)" ]; then
  echo -e "${YELLOW}Changing default shell to zsh...${NC}"
  chsh -s $(which zsh)
  echo -e "${GREEN}✓ Default shell changed to zsh (will take effect on next login)${NC}"
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
else
  echo -e "${GREEN}Oh My Zsh already installed${NC}"
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo -e "${YELLOW}Installing zsh-autosuggestions...${NC}"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  echo -e "${GREEN}✓ zsh-autosuggestions installed${NC}"
else
  echo -e "${GREEN}zsh-autosuggestions already installed${NC}"
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo -e "${YELLOW}Installing zsh-syntax-highlighting...${NC}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  echo -e "${GREEN}✓ zsh-syntax-highlighting installed${NC}"
else
  echo -e "${GREEN}zsh-syntax-highlighting already installed${NC}"
fi

# Install LazyVim
echo -e "\n${BLUE}Setting up LazyVim...${NC}"

# Verify Neovim version before installing LazyVim
final_version=$(check_nvim_version)
if [ "$final_version" == "none" ] || ! version_ge "$final_version" "$required_version"; then
  echo -e "${RED}Cannot install LazyVim: Neovim >= $required_version is required${NC}"
  echo -e "${YELLOW}Please install Neovim manually and run this script again${NC}"
  exit 1
fi

if [ -d "$HOME/.config/nvim" ]; then
  echo -e "${YELLOW}Backing up existing nvim config to ~/.config/nvim.backup${NC}"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
fi

if [ -d "$HOME/.local/share/nvim" ]; then
  echo -e "${YELLOW}Backing up existing nvim data to ~/.local/share/nvim.backup${NC}"
  mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.backup"
fi

if [ -d "$HOME/.local/state/nvim" ]; then
  echo -e "${YELLOW}Backing up existing nvim state to ~/.local/state/nvim.backup${NC}"
  mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.backup"
fi

if [ -d "$HOME/.cache/nvim" ]; then
  echo -e "${YELLOW}Backing up existing nvim cache to ~/.cache/nvim.backup${NC}"
  mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.backup"
fi

echo -e "${YELLOW}Cloning LazyVim starter...${NC}"
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
echo -e "${GREEN}✓ LazyVim installed${NC}"

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

# .tmux.conf
if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
  backup_if_exists "$HOME/.tmux.conf"
  ln -s "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
  echo -e "${GREEN}Linked .tmux.conf${NC}"
fi

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Dotfiles setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${YELLOW}source ~/.zshrc${NC}"
echo -e "  2. Open nvim to let LazyVim install plugins: ${YELLOW}nvim${NC}"
echo -e "  3. (Optional) Customize LazyVim in ${YELLOW}~/.config/nvim/lua/config/${NC}"
echo -e "\n${BLUE}Installed:${NC}"
echo -e "  • Oh My Zsh with plugins"
echo -e "  • tmux"
echo -e "  • Neovim $final_version (>= $required_version required)"
echo -e "  • LazyVim"
echo -e "  • Git configuration"
echo -e ""
