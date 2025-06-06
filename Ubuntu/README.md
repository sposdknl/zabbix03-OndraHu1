# Install Zabbix Agent2 on Ubuntu
Repositories for teaching purposes at SPOS DK

![Ubuntu and ZabbixAgent2 OSY AI](../Images/osy-Ubuntu-ZabbixAgent2.webp)

Repository pro vyuku na SPOS DK

## Automatická instalace Zabbix Agent2 na OS Linux Ubuntu

- Vagrantfile obsahuje sekci pro aplikaci příkazů pro instalaci monitorovacího
[Zabbix Agent2](https://www.zabbix.com/).

### Instalace Zabbix Agent2

```console
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest+ubuntu22.04_all.deb

apt-get update
apt-get install -y zabbix-agent2 zabbix-agent2-plugin-*

systemctl enable zabbix-agent2
systemctl start zabbix-agent2
```

### Konfigurace Zabbix Agent2

```console
joe /etc/zabbix/zabbix_agent2.conf
...
Hostname=ubuntu-8e714c18
Server=enceladus.pfsense.cz
ServerActive=enceladus.pfsense.cz
Timeout=30
HostMetadata=SPOS

systemctl restart zabbix-agent2
```

# Změny mezi verzemi Vagrantfile

Tento dokument popisuje rozdíly mezi původní a upravenou verzí souboru `Vagrantfile` pro výuku v rámci SPOS DK. Změny se týkají konfigurace virtuálního stroje Ubuntu a automatizace nasazení Zabbix Agent2.

---

## ✅ Shrnutí hlavních změn

| Oblast konfigurace            | Původní verze                           | Upravená verze                                       |
|------------------------------|------------------------------------------|------------------------------------------------------|
| **Síťová konfigurace**        | Pouze NAT s port forwardingem           | Přidána privátní síť (intnet) s IP `192.168.1.3`     |
| **Zabbix provision skripty**  | Zakomentované                           | Aktivní – volají se `install-zabbix-agent2.sh` a `configure-zabbix-agent2.sh` |
| **Záměr použití**             | Obecné testování                        | Připojení k Zabbix Appliance pro sledování hosta     |

---

## 🔧 Detaily změn

### 1. Síťová konfigurace

Do části definice VM byla přidána další síťová karta typu `private_network`, což umožňuje přímé spojení s jinými virtuálními stroji v rámci stejné `intnet` sítě (např. Zabbix Appliance):

```ruby
ubuntu.vm.network "private_network", 
    ip: "192.168.1.3", 
    virtualbox__intnet: "intnet"

### Custom config for autoreg - změna IP adresy serveru a mteadat ###
Hostname=$SHORT_HOSTNAME
Server=192.168.1.10
ServerActive=192.168.1.10
HostMetadata=SPOS
Timeout=30

...