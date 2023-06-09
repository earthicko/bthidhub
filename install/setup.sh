#!/bin/bash

cd /home/pi/bthidhub/install

sudo echo 0 | sudo tee /sys/class/leds/led0/brightness >/dev/null

sudo apt-get update -y | sudo apt-get upgrade -y

systemctl --user stop pulseaudio.socket
systemctl --user stop pulseaudio.service
systemctl --user disable pulseaudio.socket
systemctl --user disable pulseaudio.service
systemctl --user mask pulseaudio.socket
systemctl --user mask pulseaudio.service

sudo systemctl stop pulseaudio.socket
sudo systemctl stop pulseaudio.service
sudo systemctl disable pulseaudio.socket
sudo systemctl disable pulseaudio.service
sudo systemctl mask pulseaudio.socket
sudo systemctl mask pulseaudio.service

systemctl --user stop obex
systemctl --user disable obex
systemctl --user mask obex

sudo apt-get install git libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev autoconf automake libtool python3-pip -y

sudo pip3 install dasbus
sudo pip3 install asyncio
sudo pip3 install asyncio_glib
sudo pip3 install evdev
sudo pip3 install PyGObject
sudo pip3 install aiohttp >=3.8
sudo pip3 install aiohttp-security
sudo pip3 install aiohttp-session
sudo pip3 install watchgod
sudo pip3 install hid-tools==0.2
sudo pip3 install pyudev
sudo pip3 install bitarray

cd /home/pi/bthidhub/install/bluez
autoreconf -fvi

./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --disable-a2dp --disable-avrcp --disable-network
automake
make -j4

sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
sudo make install
sudo python3 /home/pi/bthidhub/install/config_replacer.py
sudo cp /home/pi/bthidhub/install/sdp_record.xml /etc/bluetooth/sdp_record.xml
sudo cp /home/pi/bthidhub/install/input.conf /etc/bluetooth/input.conf
sudo cp /home/pi/bthidhub/install/main.conf /etc/bluetooth/main.conf

sudo cp /home/pi/bthidhub/install/remapper.service /lib/systemd/system/remapper.service
sudo chmod 644 /lib/systemd/system/remapper.service
sudo systemctl daemon-reload

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable remapper.service
sudo systemctl start remapper.service

sudo hostnamectl set-hostname SK-8845
sudo sed -Ei 's/^127\.0\.1\.1.*$/127.0.1.1\tSK-8845/' /etc/hosts

sudo reboot
