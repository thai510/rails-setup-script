sudo echo "Starting installation process..."
sudo apt-get -y update
sudo apt-get -y install curl git-core python-software-properties build-essential openssl libssl-dev python g++ make checkinstall
sudo apt-get -y install postgresql libpq-dev xclip

sudo mkdir ~/src && cd $_
sudo wget -N http://nodejs.org/dist/node-latest.tar.gz
sudo tar xzvf node-latest.tar.gz && cd node-v*
sudo ./configure
sudo checkinstall
sudo dpkg -i node_*

curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
echo "Copy & Paste into the bashrc file, then press enter"
read enter
. ~/.bashrc
rbenv install 1.8.7-p371
rbenv global 1.8.7-p371
ruby -v
gem install bundler --no-ri --no-rdoc
rbenv rehash
cd ~/.ssh
bundle -v
echo "Type your email address, followed by [ENTER]:"
read address
ssh-keygen -t rsa -C "$address"
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "Copied ssh key to clipboard, please paste into your github account."
echo "What is your name?"
read username
git --config --global user.email "$address"
git --config --global user.name "$username"
sudo -u postgres psql
echo "DONE"
