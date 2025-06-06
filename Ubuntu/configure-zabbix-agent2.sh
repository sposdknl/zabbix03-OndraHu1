#!/usr/bin/env bash
 
# Unikatni hostname ubuntu (Lepší než hostname školní stanice)
UNIQUE_HOSTNAME="ubuntu-$(uuidgen)"
SHORT_HOSTNAME=$(echo $UNIQUE_HOSTNAME | cut -d'-' -f1,2)
 
# Záloha původního configu
sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig
 
# Vyčisti staré nastavení, pokud existuje (pro jistotu)
sudo sed -i '/^Hostname=/d' /etc/zabbix/zabbix_agent2.conf
sudo sed -i '/^Server=/d' /etc/zabbix/zabbix_agent2.conf
sudo sed -i '/^ServerActive=/d' /etc/zabbix/zabbix_agent2.conf
sudo sed -i '/^HostMetadata=/d' /etc/zabbix/zabbix_agent2.conf
sudo sed -i '/^Timeout=/d' /etc/zabbix/zabbix_agent2.conf
 
# Přidej nové hodnoty (na konec souboru)
cat <<EOF | sudo tee -a /etc/zabbix/zabbix_agent2.conf
 
### Custom config for autoreg ###
Hostname=$SHORT_HOSTNAME
Server=192.168.1.10
ServerActive=192.168.1.10
HostMetadata=SPOS
Timeout=30
EOF
 
# Porovnání starého a nového configu
sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf
 
# Restart agent2
sudo systemctl restart zabbix-agent2
 
 