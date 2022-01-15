#!/bin/bash

TOINSTALL=(git \
    curl \
    arm-none-eabi-gcc \
    arm-none-eabi-gdb \
    arm-none-eabi-newlib \
    aaxtomp3 \
    acpi \
    alacritty \
    alsa-utils \
    avr-gcc \
    avr-binutils \
    avr-gdb \
    avr-libc \
    qt5-wayland \
    base-devel \
    blueman \
    bluez-utils \
    clang \
    curl \
    clipit \
    cmake \
    diffutils \
    ethtool \
    firefox \
    ffmpeg \
    flameshot \
    gcc \
    gcc-libs \
    gdb \
    gnome-keyring \
    grep \
    grim \
    slurp \
    imagemagick \
    inotify-tools \
    keepassxc \
    keychain \
    man \
    make \
    mako \
    nano \
    neovim \
    openssh \
    owncloud-client \
    pcmanfm \
    python \
    python-pip \
    ranger \
    rofi \
    rofi-calc \
    shotwell \
    sof-firmware \
    telegram-desktop \
    thunderbird \
    ttf-fira-code \
    unzip \
    volumeicon \
    vlc \
    wget \
    which \
    whois \
    wl-clipboard \
    xdg-user-dirs \
    xournalpp \
    zathura \
    zathura-pdf-mupdf \
    zoom \
    zsh \
    zsh-completions)

INSTALLABLE=()
NONINSTALLABLE=()

# determine which packages are installable and stage them
for pkg in ${TOINSTALL[@]};
do
    echo "Checking for '${pkg}'.";
    if [[ $(pacman -Ss ^${pkg}$) ]];
    then
        INSTALLABLE+=($pkg);
        echo "Package '$pkg' is staged for install.";
    else
        NONINSTALLABLE+=($pkg)
        echo "Package '$pkg' must be installed manually.";
    fi
done

# really, really start fresh
rm -rf ~/.config ~/.local

# perform a complete system update. since there is nothing installed yet, this
# won't destroy any dependencies
pacman --noconfirm -Syyuu 

# install everything that's needed to get stuff from AUR 
pacman --noconfirm -Sy git curl 

# install all installable packages
pacman --noconfirm -Syu ${INSTALLABLE[@]}
# install texlive group
pacman --noconfirm -S texlive-most

# make sure we are in hom
cd ~

# used for all aur installs later o
mkdir .aurbuilds

cd ~/.aurbuilds

echo "Installing Spotify."
git clone https://aur.archlinux.org/spotify.git spotify
cd spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -
makepkg -si 
pacman -U *.tar.zst
echo "Installed Spotify."

cd ~/.aurbuilds

echo "Installing Zoom."
git clone https://aur.archlinux.org/zoom.git zoom
cd zoom
makepkg -si
pacman -U *.tar.zst
echo "Installed Zoom."

cd ~/.aurbuilds

echo "Installing VS Code."
git clone https://aur.archlinux.org/visual-studio-code-bin.git vscode
cd vscode
makepkg -si
pacman -U *.tar.zst
echo "Installed VS Code."

cd ~/.aurbuilds

echo "Installing Bluetooth AutoConnect."
git clone https://aur.archlinux.org/bluetooth-autoconnect.git bluetooth-autoconnect
cd bluetooth-autoconnect
makepkg -si
pacman -U *.tar.zst
echo "Installed Bluetooth AutoConnect."

cd ~

# check for ZSH and install as defautl shell, along with oh-my-zsh
if [[ $(which zsh) ]]
then
    echo "Set ZSH as shell."
    chsh -s $(which zsh)
    echo "Done."

    echo "Installing oh-my-zsh."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Installed oh-my-zsh."

else
    echo "Setting ZSH as shell was not possible."
fi

git clone https://github.com/mormod/scripts /tmp/scripts
cd /tmp/scripts
mv dots/.config ~/.config
mv .*profile ~

systemctl enable --now bluetooth.service

if [[ $NONINSTALLABLE ]]; 
then
    echo ${NONINSTALLABLE[@]} > ~/install-manually
    echo ""
    echo "There are some packages that have to be installed manually:"
    echo ${NONINSTALLABLE[@]}
    echo "Find a list of these at ~/install-manually"
fi
