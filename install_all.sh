#!/bin/sh
for repo in $(cat ppas.txt); do sudo add-apt-repository -y $repo; done
sudo apt-get update
cat ubuntu_packages.txt | xargs sudo apt-get install -y
sudo apt-get upgrade -y
./download_fira_mono.sh
sudo ./install-update-atom.pl
for pack in $(cat packages.txt); do apm install $pack; done
echo '#!/bin/sh' >> update-all
echo 'sudo apt-get update && sudo apt-get upgrade -y' >> update-all
echo 'sudo '$(pwd)'/install-update-atom.pl' >> update-all
echo 'yes yes | apm upgrade' >> update-all
chmod a+x update-all
sudo mv update-all /usr/bin
