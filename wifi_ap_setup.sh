#!/bin/bash 
# Based on: https://learn.adafruit.com/setting-up-a-raspberry-pi-as-a-wifi-access-point?view=all
# Or should we use https://docs.armbian.com/Developer-Guide_User-Configurations/#user-provided-image-customization-script

#TODO: use iptables to forward from eth0 to wlan0


# Install prerequisites
sudo apt install -y hostapd isc-dhcp-server

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
#sudo apt install -y iptables-persistent

echo 'option domain-name "example.org";' >> /etc/dhcp/dhcpd.conf
echo 'option domain-name-servers ns1.example.org, ns2.example.org;' >> /etc/dhcp/dhcpd.conf
echo 'authoritative;' >> /etc/dhcp/dhcpd.conf

echo 'subnet 192.168.42.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
echo 'range 192.168.42.10 192.168.42.50;' >> /etc/dhcp/dhcpd.conf 
echo 'option broadcast-address 192.168.42.255;' >> /etc/dhcp/dhcpd.conf
echo 'option routers 192.168.42.1;' >> /etc/dhcp/dhcpd.conf
echo 'default-lease-time 600;' >> /etc/dhcp/dhcpd.conf
echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf
echo 'option domain-name "local";' >> /etc/dhcp/dhcpd.conf
echo 'option domain-name-servers 8.8.8.8, 8.8.4.4;' >> /etc/dhcp/dhcpd.conf
echo '}' >> /etc/dhcp/dhcpd.conf

sed -i 's/INTERFACESv4=""/INTERFACESv4="wlan0"/g' /etc/default/isc-dhcp-server
sed -i 's/INTERFACESv6=""/INTERFACESv6="wlan0"/g' /etc/default/isc-dhcp-server

echo 'allow-hotplug wlan0' >> /etc/network/interfaces
echo 'iface wlan0 inet static' >> /etc/network/interfaces
echo 'address 192.168.42.1' >> /etc/network/interfaces
echo 'netmask 255.255.255.0' >> /etc/network/interfaces

echo 'interface=wlan0' >> /etc/hostapd/hostapd.conf
echo 'driver=nl80211' >> /etc/hostapd/hostapd.conf
echo 'ssid=Zoef' >> /etc/hostapd/hostapd.conf
echo 'country_code=US' >> /etc/hostapd/hostapd.conf
echo 'hw_mode=g' >> /etc/hostapd/hostapd.conf
echo 'channel=6' >> /etc/hostapd/hostapd.conf
echo 'macaddr_acl=0' >> /etc/hostapd/hostapd.conf
echo 'auth_algs=1' >> /etc/hostapd/hostapd.conf
echo 'ignore_broadcast_ssid=0' >> /etc/hostapd/hostapd.conf
echo 'wpa=2' >> /etc/hostapd/hostapd.conf
echo 'wpa_passphrase=Zoef_Zoef' >> /etc/hostapd/hostapd.conf
echo 'wpa_key_mgmt=WPA-PSK' >> /etc/hostapd/hostapd.conf
echo 'wpa_pairwise=CCMP' >> /etc/hostapd/hostapd.conf
echo 'wpa_group_rekey=86400' >> /etc/hostapd/hostapd.conf
echo 'ieee80211n=1' >> /etc/hostapd/hostapd.conf
echo 'wme_enabled=1' >> /etc/hostapd/hostapd.conf

sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="/etc/hostapd/hostapd.conf"/g' /etc/default/hostapd
sed -i 's/DAEMON_CONF=/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/g' /etc/init.d/hostapd

# Enable IP forwarding
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

#echo '*nat' >> /etc/iptables/rules.v4
#echo ':PREROUTING ACCEPT [0:0]' >> /etc/iptables/rules.v4
#echo ':INPUT ACCEPT [0:0]' >> /etc/iptables/rules.v4
#echo ':OUTPUT ACCEPT [0:0]' >> /etc/iptables/rules.v4
#echo ':POSTROUTING ACCEPT [0:0]' >> /etc/iptables/rules.v4
#echo '-A POSTROUTING -o eth0 -j MASQUERADE' >> /etc/iptables/rules.v4

#echo '*filter' >> /etc/iptables/rules.v4
#echo ':INPUT ACCEPT [1215:342535]' >> /etc/iptables/rules.v4
#echo ':FORWARD DROP [0:0]' >> /etc/iptables/rules.v4
#echo ':OUTPUT ACCEPT [1211:343275]' >> /etc/iptables/rules.v4
#echo '-A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT' >> /etc/iptables/rules.v4
#echo '-A FORWARD -i wlan0 -o eth0 -j ACCEPT' >> /etc/iptables/rules.v4

# Added systemd service to account for fix: https://askubuntu.com/questions/472794/hostapd-error-nl80211-could-not-configure-driver-mode
echo '[Unit]' >> /lib/systemd/system/zoef_ap.service
echo 'Description=Zoef Wifi AP' >> /lib/systemd/system/zoef_ap.service
echo 'After=network.target' >> /lib/systemd/system/zoef_ap.service
echo 'After=ssh.service' >> /lib/systemd/system/zoef_ap.service
echo 'After=network-online.target' >> /lib/systemd/system/zoef_ap.service
echo '' >> /lib/systemd/system/zoef_ap.service
echo '[Service]' >> /lib/systemd/system/zoef_ap.service
echo 'ExecStart=/root/zoef_ap.sh' >> /lib/systemd/system/zoef_ap.service
echo '' >> /lib/systemd/system/zoef_ap.service
echo '[Install]' >> /lib/systemd/system/zoef_ap.service
echo 'WantedBy=multi-user.target' >> /lib/systemd/system/zoef_ap.service

echo '#!/usr/bin/env bash' >> /root/zoef_ap.sh
echo 'bash -c "sudo nmcli radio wifi off && sudo rfkill unblock wlan && sudo ifconfig wlan0 192.168.42.1/24 up && sleep 1 && sudo service isc-dhcp-server restart && sudo service hostapd restart"' >> /root/zoef_ap.sh
chmod +x /root/zoef_ap.sh

# Enable all services
systemctl enable hostapd
systemctl enable isc-dhcp-server
systemctl enable zoef_ap

# Add zoef user with sudo rights
useradd -m -G sudo -s /bin/bash zoef
echo -e "zoef_zoef\nzoef_zoef" | passwd zoef
passwd --expire zoef

# Disable ssh root login
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config


