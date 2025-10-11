# Tools you will need (apt packackage manager)

sudo apt update
sudo apt install -y git tmux zsh i3wm i3blocks

#TODO:
#1. install neovim (build from source)
#2. install vscode
#3. install rofi
#4. install slicer (flathub)
#5. install fzf
#6. install go
#7. install fd

#Set a default wallpaper 
#1. download wallpaper from:
#2. set it with feh

#Download pango nerd font

#Locally build apps
mkdir ~/Apps
#Install rofi-code:
git clone https://github.com/Coffelius/rofi-code.git ~Apps/rofi-code
# then make install

#8. install lazygit
#9. install delta (pager for git)


#Configure terminal
#1. Install a package manger for ZSH (oh-my-zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#2. Install used plugins 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

