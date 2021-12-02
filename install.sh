#! /usr/bin/bash

pacman -Syy
pacman -Sy --noconfirm base-devel git rofi flameshot firefox htop keepassxc owncloud-client nautilus zathura neovim xcursor-breeze ttf-fira-code texlive-science texlive-science texlive-bin make cmake dunst vlc 

# Install NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Prepare aurutils for automated AUR installs
mkdir ~/.aur-builds
git clone https://aur.archlinux.org/aurutils.git
cd ~/.aur-builds/aurutils-git
makepkg -si

cp aurutils/custom /etc/pacman.d/custom
echo "Inculde = /etc/pacman.d/custom" >> /etc/pacman.conf
sudo install -d /var/cache/pacman/custom -o $USER
repo-add /var/cache/pacman/custom/custom.db.tar

# Install telegram-desktop 
git 
