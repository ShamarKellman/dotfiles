#!/bin/sh

echo "Setting up your machine..."

echo "Creating .hushlogin for quiet logins"
touch ~/.hushlogin

# Check for PHP and install if we don't have it
if test ! $(which php); then
    echo "Installing PHP"
    sudo apt install php
fi

echo "PHP Installed"

# Check for composer and install if we don't have it
if test ! $(which composer); then
    echo "Downloading composer"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    echo "Verifying dowload"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    echo "Installing composer"
    php composer-setup.php
    echo "Moving composer to global location"
    sudo mv composer.phar /usr/local/bin/composer
    echo "cleaning up"
    php -r "unlink('composer-setup.php');"
fi

echo "Composer Installed"


# Check for docker and install if we don't have it
if test ! $(which docker); then
    echo "Installing Docker"
    sudo apt install docker.io
    echo "Enabling Docker"
    sudo systemctl enable --now docker
    echo docker --version
fi

echo "Docker Installed"

# Check for docker-compose and install if we don't have it
if test ! $(which docker-compose); then
    echo "Downloading Docker Compose"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    echo "Fixing permissions"
    sudo chmod +x /usr/local/bin/docker-compose
    echo docker-compose --version
fi

echo "Docker Compose Installed"

# Install Laravel Installer
echo "Installing Laravel Installer"
composer global require laravel/installer
echo "laravel/installer Installed"

# Check for ZSH and install if we don't have it
if test ! $(which zsh); then
    echo "Installing ZSH"
    sudo apt install zsh
    echo "Installing Powerline Fonts"
    sudo apt-get install powerline fonts-powerline
    echo "Cloning Oh My ZSH"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    echo "Creating configuration file"
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    echo "Changing Shell"
    chsh -s /bin/zsh
fi

echo "Oh My ZSH Installed"

if test ! $(which starship); then
    echo "Installing starship.rs"
    curl -fsSL https://starship.rs/install.sh | bash
    echo "starship.rs installed"
    echo "making ~/.config directory"
    mkdir -p ~/.config
fi

echo "Soft Linking dotfile starship.toml file"
rm -rf $HOME/.config/startship.toml
ln -s $HOME/github/JustSteveKing/dotfiles/.starship.toml $HOME/.config/startship.toml

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
echo "Removing default .zshrc file"
rm -rf $HOME/.zshrc

echo "Soft Linking dotfile .zshrc files"
ln -s $HOME/github/JustSteveKing/dotfiles/.zshrc $HOME/.zshrc

echo "Setting up git"
git config --global user.name "Steve McDougall"
git config --global user.email juststevemcd@gmail.com

echo "Setting default git branch name to main"
git config --global init.defaultBranch main

echo "Creating global gitignore file"
rm -rf $HOME/.gitignore
ln -s $HOME/github/JustSteveKing/dotfiles/gitignore $HOME/.gitignore
git config --global core.excludesfile ~/.gitignore
