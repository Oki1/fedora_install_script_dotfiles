#!/bin/bash
set -euo pipefail
trap 'echo -e "\n ERROR at line $LINENO: $BASH_COMMAND (exit code: $?)" >&2' ERR

#enable rpm
sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf upgrade --refresh -y
    sudo dnf group upgrade -y core
    sudo dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted dnf-plugins-core

#enable flatpak
sudo dnf install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
    
#pkgs
sudo dnf install -y git neovim alacritty flameshot zsh btrfs-assistant

curl -fsSL https://repo.librewolf.net/librewolf.repo | pkexec tee /etc/yum.repos.d/librewolf.repo
sudo dnf install -y librewolf
sudo dnf install -y https://vencord.dev/download/vesktop/amd64/rpm

# vscodium
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
sudo dnf install codium

sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
snap install ferdium
sudo dnf install https://vencord.dev/download/vesktop/amd64/rpm

sudo dnf install rustup
rustup-init
~/.cargo/bin/cargo install du-dust


shell
curl -sS https://starship.rs/install.sh | sh
#zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
#prepend zsh stuff
echo "autoload -Uz zargs
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
bindkey -e
zstyle :compinstall filename '/home/freg/.zshrc'
autoload -Uz compinit
compinit
eval \"\$(starship init zsh)\"
$(cat ~/.zshrc)

zinit load zimfw/input
zinit load zsh-users/zsh-completions
zinit load zdharma/fast-syntax-highlighting" > ~/.zshrc

#mamba
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
rm Miniforge3-$(uname)-$(uname -m).sh
~/miniforge3/bin/conda init zsh

#get fonts

wget -P ~/.local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -P ~/.local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -P ~/.local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -P ~/.local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

chsh -s /bin/zsh


#
# mkdir -p ~/.config/nvim
# git clone https://github.com/Oki1/neovim_configuration.git ~/.config/nvim
# mkdir -p ~/.config/alacritty
# git clone https://github.com/Oki1/alacritty_conf.git ~/.config/alacritty
# https://github.com/Oki1/alacritty_conf.git

#move configs
cp -rf ./dotfiles/.config ~/

#timesfhitt
#background
