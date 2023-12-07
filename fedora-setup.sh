#!/usr/bin/env bash

# TESTED WITH: Fedora 39 Workstation

if [[ "$USER" = 0 ]]; then
    echo "This script should not be run as root!"
    exit 1
fi

sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.backup
echo -e 'defaultyes=True\nmax_parallel_downloads=10\nretries=5\ninstall_weak_deps=False' | sudo tee -a /etc/dnf/dnf.conf

# Update all apps, first
sudo dnf upgrade -y --refresh
# Also update the firmware
sudo fwupdmgr get-devices 
sudo fwupdmgr refresh --force 
sudo fwupdmgr get-updates 
sudo fwupdmgr update

# Installs the rpmfusion repository
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate -y core


# This removes all desktop applications except gnome-terminal and nautilus.
# Desktop applications
sudo dnf remove -y baobab cheese* evince* firefox gnome-boxes gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-connections gnome-contacts gnome-disk-utility gnome-font-viewer gnome-logs gnome-maps gnome-remote-desktop gnome-shell-extension-* gnome-text-editor gnome-tour gnome-user-docs gnome-weather libreoffice* loupe mozilla-filesystem rhythmbox totem yelp*
# Fedora specific packages
sudo dnf remove -y fedora-bookmarks fedora-chromium-config mediawriter fedora-flathub-remote
# Scanning support - COMMENT OUT if you need scanning support for printers
sudo dnf remove -y sane* simple-scan
# Unneeded xorg drivers - COMMENT OUT if you use an AMD or Intel GPU
sudo dnf remove -y xorg-x11-drv-amdgpu xorg-x11-drv-ati amd-gpu-firmware xorg-x11-drv-intel xorg-x11-drv-wacom xorg-x11-drv-openchrome
# Windows compatibility, and Windows Active Directory
sudo dnf remove -y sssd* samba-client dos2unix
# Virtualization stuff - COMMENT OUT if in virtual machine
sudo dnf remove -y hyperv* *qemu* virtualbox-guest-additions xorg-x11-drv-vmware

# If using NVIDIA GPU:
#sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power vulkan xorg-x11-drv-nvidia-cuda-libs nvidia-vaapi-driver libva-utils vdpauinfo
#sudo systemctl enable nvidia-{suspend,resume,hibernate}

sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Setup flatpak apps
# Cheese is now EOL
flatpak install flathub \
com.brave.Browser \
com.discordapp.Discord \
com.github.tchx84.Flatseal \
com.github.unrud.VideoDownloader \
com.rafaelmardojai.Blanket \
com.raggesilver.BlackBox \
com.valvesoftware.Steam \
de.haeckerfelix.Fragments \
io.bassi.Amberol \
io.github.seadve.Kooha \
org.DolphinEmu.dolphin-emu \
org.gimp.GIMP \
org.gnome.baobab \
org.gnome.Calculator \
org.gnome.clocks \
org.gnome.Evince \
org.gnome.font-viewer \
org.gnome.Logs \
org.gnome.Loupe \
org.gnome.Snapshot \
org.gnome.TextEditor \
org.gnome.World.PikaBackup \
org.jdownloader.JDownloader \
org.libreoffice.LibreOffice \
org.libretro.RetroArch \
org.prismlauncher.PrismLauncher

# Nice fonts
sudo dnf install -y jetbrains-mono-fonts 
# Archive support, because for some reason Fedora doesn't have them installed by default
sudo dnf install -y p7zip unrar p7zip-plugins