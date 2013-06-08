sudo echo "Starting installation process..."
sudo apt-get -y update
sudo apt-get -y install curl git-core python-software-properties build-essential openssl libssl-dev python g++ make checkinstall
sudo apt-get -y install postgresql libpq-dev

sudo mkdir ~/src && cd $_
sudo wget -N http://nodejs.org/dist/node-latest.tar.gz
sudo tar xzvf node-latest.tar.gz && cd node-v*
sudo ./configure
sudo checkinstall
sudo dpkg -i node_*

TEXT='if [ -d $HOME\/.rbenv ]; then\nexport PATH="$HOME\/.rbenv\/bin:$PATH"\neval "$(rbenv init -)"\nfi\n[ -z "$PS1" ] && return\n'

curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
sed -i '1s/^/$TEXT\n/' ~/.bashrc
. ~/.bashrc
rbenv install 1.9.3-p125
rbenv global 1.9.3-p125
ruby -v
gem install bundler --no-ri --no-rdoc
rbenv rehash
bundle -v
sudo -u postgres psql
echo "DONE"
