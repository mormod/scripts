#!/bin/bash

if [[ $(id -u) -eq 0 ]]; then
    sudo -k
    echo "Please execute as non-root user."
    exit 1
fi

AURBUILDDIR=$HOME/.aurbuilds

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
    chezmoi \
    clang \
    curl \
    clipit \
    cmake \
    diffutils \
    ethtool \
    firefox \
    ffmpeg \
    gcc \
    gcc-libs \
    gdb \
    gnome-keyring \
    grep \
    git \
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
    texlive-most \
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
    vim \
    zsh \
    zsh-completions)

TOINSTALLAUR=(aaxtomp3 \
    adwaita-dark \
    bluetooth-autoconnect \
    brother-hl2030 \
    cozy-audiobooks-git \
    mako \
    nerd-fonts-fira-code \
    ntfs3-dkms \
    papirus-icon-theme-git \
    rofi-lbonn-wayland \
    visual-studio-code-bin \
    xcursor-breeze \
    xp-pen-tablet \
    zoom)

INSTALLABLE=()
NONINSTALLABLE=()

###########################################################################
### pacman stuff ##########################################################
###########################################################################

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

# gain root permissions
su -

# perform a complete system update. since there is nothing installed yet, this
# won't destroy any dependencies
pacman --noconfirm -Syyuu
# install all installable packages
pacman --noconfirm -S ${INSTALLABLE[@]}

# become normal user again
logout

###########################################################################
### AUR stuff #############################################################
###########################################################################

echo "Creating AUR build directory at '" $AURBUILDDIR "'"
# used for all aur installs later
mkcd -p $AURBUILDDIR

# install yay
echo "Installing YAY"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sic 
echo "Installed YAY"

for pkg in ${TOINSTALLAUR[@]};
do
    echo "Installing" $pkg
    yay --builddir=$AURBUILDDIR --searchby name --mflags "-sic" --sudoloop $pkg
    echo "Installed" $pkg
done

echo "Installing spotify"
git clone https://aur.archlinux.org/spotify.git spotify
cd spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -
makepkg -si
echo "Installed spotify"

###########################################################################
### ZSH stuff #############################################################
###########################################################################

cd ~

# check for ZSH and install as default shell, along with oh-my-zsh
if [[ $(which zsh) ]]
then
    echo "Set ZSH as shell."
    chsh -s $(which zsh)
    echo "Done."

    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Installed oh-my-zsh"

else
    echo "Setting ZSH as shell was not possible."
fi

###########################################################################
### config stuff ##########################################################
###########################################################################

mkdir ~/src
git clone https://github.com/mormod/scripts ~/src/scripts

chezmoi init --apply https://github.com/mormod/dotfiles.git

# make light (display brightness) executeable without root
sudo usermod -aG video $(id -un) 
# enable bluetooth
systemctl enable --now bluetooth.service
systemctl enable --now bluetooth-autostart.service

###########################################################################
### wrapup stuff ##########################################################
###########################################################################

if [[ $NONINSTALLABLE ]];
then
    echo ${NONINSTALLABLE[@]} > ~/install-manually
    echo "\nThere are some packages that have to be installed manually:"
    echo ${NONINSTALLABLE[@]}
    echo "Find a list of these at ~/install-manually"
fi
