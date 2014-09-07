#!/bin/bash

sudo echo "Checking to make sure we're the deployer user"...
if [ "$USER" != "deployer" ]; then
  echo "Using root account. Create deployer account? (y/N)"
  read proceed
  if [ "$proceed" == "y" ]; then
    adduser deployer
    echo 'deployer ALL=(ALL:ALL) ALL' >> /etc/sudoers
    echo "Please log out, and log back in as the user: deployer"
  fi
  exit
fi
sudo echo "Starting installation process..."
sudo apt-get -y update
sudo apt-get -y install curl git-core python-software-properties build-essential openssl libssl-dev python g++ make checkinstall
sudo apt-get -y install postgresql libpq-dev xclip libxslt-dev libxml2-dev nodejs

echo "Setting up Ruby..."
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
. ~/.bashrc
/home/deployer/.rbenv/bin/rbenv install 1.9.3-p125
/home/deployer/.rbenv/bin/rbenv global 1.9.3-p125
ruby -v
gem install bundler --no-ri --no-rdoc
/home/deployer/.rbenv/bin/rbenv rehash
cd ~/.ssh
bundle -v
echo "Type your email address, followed by [ENTER]:"
read address
ssh-keygen -t rsa -C "$address"
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "Copied ssh key to clipboard, please paste into your bitbucket account."
echo "What is your name?"
read username
git --config --global user.email "$address"
git --config --global user.name "$username"
echo "Please make a postgres user and db. Use the following commands:"
echo "create user dcm password 'password123';"
echo "create database dcm_production owner dcm;"
echo "\quit"
sudo -u postgres psql
echo "DONE. Now run on your local machine: cap <env> deploy:setup, cap <env> deploy:check, and cap <env> deploy:cold."
