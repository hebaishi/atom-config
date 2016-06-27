#!/bin/sh
cd /tmp
curl https://www.fontsquirrel.com/fonts/download/fira-mono -o fira-mono.zip
unzip fira-mono.zip
sudo mkdir /usr/share/fonts/opentype/FiraMono
sudo cp *.otf /usr/share/fonts/opentype/FiraMono
fc-cache -f -v
