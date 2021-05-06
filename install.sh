GIT_USER_NAME=GITHUB_USER_NAME
GIT_EMAIL=GITHUB_EMAIL
GITHUB_PACKAGES_TOKEN=TOKEN # settings => developer settings => personal access tokens


# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

echo "Make sure to edit .zshrc with t"

# Applications
brew install --cask iterm2
brew install --cask webstorm
brew install --cask goland
brew install --cask datagrip
brew install --cask visual-studio-code
brew install --cask postman
brew install --cask telegram
brew install --cask sublime-text
brew install --cask dashlane
brew install --cask slack

# go
brew install go
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
git config --global url.git@github.com:.insteadOf https://github.com
echo "export GOPRIVATE=\"github.com/climacell/*\"" >> ~/.zshrc

# Node
brew install nvm
brew install yarn
echo "//npm.pkg.github.com/:_authToken=$GITHUB_PACKAGES_TOKEN" > ~/.npmrc

# VPN
brew install --cask tunnelblick
brew install --cask openvpn-connect

# Gcloud
brew install --cask google-cloud-sdk
gcloud init

# K8s
brew install kubectl
brew install kubectx
brew install k9s
brew install fzf
brew install --cask lens

# docker
brew install --cask docker

# Git
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

#github
brew install gh

# SSH
ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL"

# P4merge
brew cask install p4v
git config --global merge.tool p4mergetool
git config --global mergetool.p4mergetool.cmd 
git config --global mergetool.p4mergetool.cmd "/usr/local/Caskroom/p4merge.app/Contents/Resources/launchp4merge \$PWD/\$BASE \$PWD/\$REMOTE \$PWD/\$LOCAL \$PWD/\$MERGED"
git config --global mergetool.p4mergetool.trustExitCode false
git config --global mergetool.keepBackup false
git config --global diff.tool p4mergetool
git config --global difftool.p4mergetool.cmd "/usr/local/Caskroom/p4merge.app/Contents/Resources/launchp4merge \$LOCAL \$REMOTE"

#Configurations
# echo "prompt_context() {
#   if [[ \"\$USER\" != \"\$DEFAULT_USER\" || -n \"\$SSH_CLIENT\" ]]; then
#     prompt_segment black default \"%(!.%{%F{yellow}%}.)\$USER\"
#   fi
# }

echo "# Default editor
export EDITOR='subl -w'

# NVM
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm
[ -s \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\" ] && . \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion

# Gcloud
source \"/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc\"
source \"/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc\"

# Blazemeter
brew install bzt

[[ -s \"\$HOME/.gvm/scripts/gvm\" ]] && source \"\$HOME/.gvm/scripts/gvm\"" >> ~/.zshrc

# Folders
mkdir ~/dev


