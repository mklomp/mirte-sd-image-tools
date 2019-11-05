#bin/bash

if [ ! -f /etc/ssid ]; then
    sudo bash -c "sudo echo Zoef_`cat /dev/urandom | tr -dc \'a-zA-Z0-9\' | fold -w 6 | head -n 1` > /etc/ssid"
fi

sudo service dnsmasq stop
sleep 15

iwgetid -r

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'
else
    printf 'Starting WiFi Connect\n'
    sudo wifi-connect -o 8080 -p zoef_zoef -s `cat /etc/ssid`
    sudo service dnsmasq start
fi

