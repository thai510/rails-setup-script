echo "Starting installation process..."
echo "Install packages? (y/n)"
read installPackages
echo "Download & Install Qt 4.7.4? (y/n)"
read installQt
echo "Download & Install Ruby 1.8.7? (y/n)"
read installRuby
echo "Download & Install Git? (y/n)"
read installGit
echo "Clone TechUSB Repo? (y/n)"
read cloneRepo

if [[ "$installPackages" == "y" ]]; then
  echo "Updating..."
	sudo apt-get -y update
	echo "Installing necessary packages..."
	sudo apt-get -y install curl git-core python-software-properties build-essential openssl libssl-dev python g++ make checkinstall
	sudo apt-get -y install postgresql libpq-dev xclip libxext-dev
	sudo mkdir ~/src && cd $_
	sudo wget -N http://nodejs.org/dist/node-latest.tar.gz
	sudo tar xzvf node-latest.tar.gz && cd node-v*
	sudo ./configure
	sudo checkinstall
	sudo dpkg -i node_*
fi


if [[ "$installQt" == "y" ]]; then
	cd /tmp
	sudo wget -N http://download.qt-project.org/archive/qt/4.7/qt-everywhere-opensource-src-4.7.4.tar.gz
	sudo tar xzvf qt-everywhere-opensource-src-4.7.4.tar.gz
	cd qt-everywhere-opensource-src-4.7.4
	./configure
	echo "How many CPU cores does this computer have? (Choose: 1,2,4)"
	read cores
	if [[ "$cores" == "1" ]]; then
		make
	elif [[ "$cores" == "2" ]]; then
		make -j2
	elif [[ "$cores" == "4" ]]; then 
		make -j4
	else
		make
	fi
fi

if [[ "$installRuby" == "y" ]]; then
	echo "Downloading and Installing Ruby 1.8.7-p371 via Rbenv..."
	curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
	echo "Copy & Paste the lines above as stated into the bashrc file, then press enter"
	read enter
	. ~/.bashrc
	rbenv install 1.8.7-p371
	rbenv global 1.8.7-p371
	ruby -v
	gem install bundler --no-ri --no-rdoc
	gem install rake
	rbenv rehash
	cd ~/.ssh
	bundle -v
fi


if [[ "$installGit" == "y" ]]; then
	echo "Type your email address, followed by [ENTER]:"
	read address
	ssh-keygen -t rsa -C "$address"
	ssh-add
	xclip -sel clip < ~/.ssh/id_rsa.pub
	echo "What is your name?"
	read username
	git config --global user.email "$address"
	git config --global user.name "$username"
	sudo -u postgres psql
	echo "You're all set."
	echo "Copied ssh key to clipboard, please paste into your github account on github.com, then press enter."
	read enter
fi

if [[ "$cloneRepo" == "y" ]]; then
	mkdir -p ~/Repositories
	cd ~/Repositories
	git clone git@github.com:thai510/Tech-USB.git
fi

echo "ALL DONE!"
