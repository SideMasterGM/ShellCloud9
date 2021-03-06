#! /bin/bash
echo "                 ___ "
echo "┌─┐┬  ┌─┐┬ ┬┌┬┐ / _ \\"
echo "│  │  │ ││ │ ││ \_, /"
echo "└─┘┴─┘└─┘└─┘─┴┘  /_/"


# Installing packages
echo "Preparing System"
sudo apt-get update
sudo apt-get install -y \
	python \
	make \
	nodejs-legacy \
	build-essential \
	g++ curl \
	libssl-dev \
	apache2-utils \
	git \
	libxml2-dev \
	tmux


# Upgrading system optional
while true
do
  echo "Upgrade system [Optional]"
  echo -n "'yes' or 'no': "
  read REPLY
  case $REPLY in
    'yes')
      upgrade=1
      break;;
    'no')
      upgrade=0
      break;;
    *)
      echo "Wrong input try again";;
  esac
done
if [ "$upgrade" == 1 ]
  then
    sudo apt-get upgrade
    echo "Success!"
elif [ "$upgrade" == 0 ]
  then
    echo "Upgrade cancelled"
fi

echo "Making Directory"
mkdir ~/github
cd ~/github

echo "Cloning C9 core"
git clone https://github.com/c9/core
echo "Done!"

# install nvm to use node 0.10
echo "Cloning NVM"
git clone https://github.com/creationix/nvm.git ~/.nvm
echo "Done!"

echo "Installing Node 0.10"
source ~/.nvm/nvm.sh
nvm install 0.10
echo "Done!"

# setting up cloud9
echo "Setting up Cloud9"
cd core
npm install packager
npm install
./scripts/install-sdk.sh
echo "Done!"

# setting up start script
mkdir $HOME/.scripts
echo "export PATH=$PATH:$HOME/.scripts/" >> $HOME/.bashrc
cat > $HOME/.scripts/cloud9-server << EOF
#! /bin/bash
source ~/.nvm/nvm.sh
cd ~/github/core/
node ./server.js -p 3000 -a : -w '/home/network/'
EOF
chmod +x ~/.scripts/cloud9-server
echo "Done!"

echo "Now restart the shell and use cloud9-server to start the server"