POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--git-user-name)
      GIT_USER_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--git-email)
      GIT_EMAIL="$2"
      shift # past argument
      shift # past value
      ;;
    -t|--github-packages-token)
      GITHUB_PACKAGES_TOKEN="$2"
      shift # past argument
      shift # past value
      ;;
    -x|--exclude)
      IFS=',' read -r -a EXCLUDE <<< "$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

usage (){
  echo "Usage: ./install.sh -u|--git-user-name <YOUR-GIT-USER-NAME> -e|--git-email <YOUR-GIT-EMAIL> -t|--github-packages-token <GITHUB-PACKAGES-TOKEN> [-x|--exclude <comma separated string for apps that will not be installed>]"
  echo "Usage: Github packages token can be fetched from: github.com => settings => developer settings => personal access tokens"
  echo "Usage: Available excludes: whatsapp,telegram,visual-studio-code,github,gh,notion,ngrok,goland,awscli,gcloud,sublime-text,go,mongo,tunnelblick,openvpn-connect,k8s,bzt,terraform,iterm2"
}

if [ -z "${GIT_USER_NAME}" ] || [ -z "${GIT_EMAIL}" ] || [ -z "${GITHUB_PACKAGES_TOKEN}" ]; then
  usage
  exit 1
fi

arrayContains (){
  declare -a array=("${!1}")
  local match=$2

  for item in "${array[@]}"
  do
    if [[ "$item" == "$match" ]]; then
      return 1
    fi
  done

  return 0
}

install (){
  local name=$1
  local options=$2
  arrayContains EXCLUDE[@] $name
  if [[ "$?" == "0" ]]; then
    brew install ${options} $name
  fi
}

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
BREW_PREFIX=$(brew --prefix)
echo "eval \"$(${BREW_PREFIX}/bin/brew shellenv)\"" >> $HOME/.zprofile
eval "$(${BREW_PREFIX}/bin/brew shellenv)"

# Zsh
0>/dev/null sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# Applications
install notion --cask 
install iterm2 --cask

# Dev Apps
brew install --cask webstorm
brew install --cask pycharm
brew install --cask postman
brew install --cask datagrip
install goland --cask 
install ngrok --cask 
install github --cask

# Cloud CLIs
install awscli
arrayContains EXCLUDE[@] gcloud
if [[ "$?" == "0" ]]; then
  brew install --cask google-cloud-sdk
  gcloud init
  echo "source \"${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc\"" >> ~/.zshrc
  echo "source \"${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc\"" >> ~/.zshrc
fi
arrayContains EXCLUDE[@] heroku
if [[ "$?" == "0" ]]; then
  brew tap heroku/brew && brew install heroku
fi

# Text editors
install atom --cask
install sublime-text --cask 
install visual-studio-code --cask

# Communication
install whatsapp --cask
install telegram --cask
brew install --cask slack
brew install --cask zoom

# Mongo
arrayContains EXCLUDE[@] mongo
if [[ "$?" == "0" ]]; then
  brew install --cask mongodb-compass
  brew tap mongodb/brew
  brew install mongodb-database-tools
fi

# Node
brew install nvm
brew install yarn
echo "//npm.pkg.github.com/:_authToken=$GITHUB_PACKAGES_TOKEN" > ~/.npmrc
nvm install 12
nvm install 16
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc
# This loads nvm
[ -s \"${BREW_PREFIX}/opt/nvm/nvm.sh\" ] && echo "\. \"${BREW_PREFIX}/opt/nvm/nvm.sh\"" >> ~/.zshrc
# This loads nvm bash_completion
[ -s \"${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm\" ] && echo "\. \"${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm\"" >> ~/.zshrc

# go
arrayContains EXCLUDE[@] go
if [[ "$?" == "0" ]]; then
  brew install go
  zsh $(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  git config --global url.git@github.com:.insteadOf https://github.com
  echo "export GOPRIVATE=\"github.com/climacell/*\"" >> ~/.zshrc
  [[ -s \"\$HOME/.gvm/scripts/gvm\" ]] && echo "source \"\$HOME/.gvm/scripts/gvm\"" >> ~/.zshrc
fi

# docker
brew install --cask docker

# Git
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

# P4merge
brew install --cask p4v
git config --global merge.tool p4mergetool
git config --global mergetool.p4mergetool.cmd 
git config --global mergetool.p4mergetool.cmd "/Applications/p4merge.app/Contents/MacOS/p4merge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\""
git config --global mergetool.p4mergetool.trustExitCode false
git config --global mergetool.keepBackup false
git config --global diff.tool p4mergetool
git config --global difftool.p4mergetool.cmd "/Applications/p4merge.app/Contents/MacOS/p4merge \"$LOCAL\" \"$REMOTE\""

# VPN
install tunnelblick --cask 
install openvpn-connect --cask 

# K8s
arrayContains EXCLUDE[@] k8s
if [[ "$?" == "0" ]]; then
  brew install kubectl
  brew install kubectx
  brew install k9s
  brew install fzf
  brew install --cask lens
fi

#github
install gh

# SSH
ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL"

#Configurations
# echo "prompt_context() {
#   if [[ \"\$USER\" != \"\$DEFAULT_USER\" || -n \"\$SSH_CLIENT\" ]]; then
#     prompt_segment black default \"%(!.%{%F{yellow}%}.)\$USER\"
#   fi
# }

# Default editor
arrayContains EXCLUDE[@] sublime-text
if [[ "$?" != "0" ]]; then
  echo "# Default editor"
  export EDITOR='subl -w'  
fi

# Blazemeter
install bzt

# Folders
mkdir ~/dev

# terraform
arrayContains EXCLUDE[@] terraform
if [[ "$?" == "0" ]]; then
  brew install warrensbox/tap/tfswitch
fi

# Rosseta
softwareupdate --install-rosetta

echo "Make sure to edit .zshrc with a theme you like"
