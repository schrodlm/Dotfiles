# Tools you will need (apt packackage manager)

sudo apt update
sudo apt install -y git tmux zsh i3wm i3blocks

#TODO:
#1. install neovim (build from source)
#2. install vscode
#3. install slicer (flathub)

#Configure terminal
#1. Install a package manger for ZSH (oh-my-zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#2. Install used plugins 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$ZSH_CUSTOM/plugins/autoswitch_virtualenv"


