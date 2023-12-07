#!/usr/bin/env bash

if [[ "$USER" = 0 ]]; then
    echo "This script should not be run as root!"
    exit 1
fi

# Configure pacman
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo cp /etc/pacman/mirrorlist /etc/pacman/mirrorlist.bak
reflector --ipv4 --protocol https --country au,nz,id,sg,tw --sort rate --fastest 5

# Install core packages
sudo pacman -Syu
sudo pacman -S --needed --noconfirm ark audiocd-kio baloo-widgets base-devel bash-completion breeze breeze-gtk btop calibre discord discover dolphin dolphin-plugins ffmpegthumbs filelight flatpak flatpak-kcm gimp git gwenview haruna hunspell hunspell-en_au kate kcalc kde-gtk-config kde-inotify-survey kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-thumbnailers kget kimageformats5 kio-admin kio-extras kio-fuse kio-gdrive kolourpaint kompare konsole krename krita krunner5 ksystemlog libappindicator-gtk3 libheif libreoffice-fresh nano nano-syntax-highlighting neofetch networkmanager okular openssh pacman-contrib partitionmanager phonon-qt5-vlc plasma-browser-integration pipewire plasma-desktop plasma-nm plasma-pa plasma-wayland-session powerdevil qt5-imageformats sonnet5 spectacle sweeper taglib vulkan vulkan-utils wayland wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xdg-user-dirs xorg-server xorg-xwayland xsettingsd yakuake bluedevil sddm sddm-kcm

echo "Bluetooth - Enabling bluetooth.service"
sudo systemctl enable --now bluetooth.service

echo "Bluetooth - Enabling btusb module"
sudo modprobe btusb

echo "Printing support..."
printing_pkgs=(cups cups-pdf print-manager system-config-printer)
sudo pacman -S --needed --noconfirm "${printing_pkgs[@]}"
sudo systemctl enable --now cups.service

echo "Removing package conflicts"
sudo pacman -Rs --no-confirm xdg-desktop-portal-gnome qt5ct

# NVIDIA
sudo pacman -S --needed --no-confirm nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
if pacman -Q | grep 'gdm'; then
    sudo systemctl enable nvidia-resume.service
fi

echo "Installing paru"
sudo pacman -S --needed --no-confirm paru

# Setup AUR packages
paru -S ttf-google-fonts-git visual-studio-code-bin jetbrains-toolbox brave-bin vmware-workstation strawberry-qt5 jdownloader2 qbittorrent-qt5

# Setup VMWare Workstation
sudo systemctl start vmware-networks-configuration.service
sudo systemctl enable --now vmware-networks.service
sudo systemctl enable --now vmware-usbarbitrator.service
sudo modprobe -a vmw_vmci vmmon

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo