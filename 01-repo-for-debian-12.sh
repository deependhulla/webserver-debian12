#!/bin/sh

# for Debian 12

## set to India IST timezone -- You can dissable it if needed
timedatectl set-timezone 'Asia/Kolkata'

##disable ipv6 as most time not required
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null

## backup existing repo by copy just for safety
mkdir -p /opt/old-config-backup/ 2>/dev/null
/bin/cp -pR /etc/apt/sources.list /opt/old-config-backup/old-sources.list-`date +%s`
echo "" >  /etc/apt/sources.list

echo "deb http://deb.debian.org/debian/ bookworm main non-free-firmware contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bookworm-security main non-free-firmware contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware contrib non-free" >> /etc/apt/sources.list

## set to India IST timezone -- You can dissable it if needed
timedatectl set-timezone 'Asia/Kolkata'

#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8


apt update
apt -y upgrade
apt -y dist-upgrade

CFG_HOSTNAME_FQDN=`hostname -f`
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
DEBIAN_FRONTEND=noninteractive

## few tools need for basic with email 
## install insstead of systemd-timesyncd for better time sync
apt -y install vim chrony openssh-server screen net-tools git mc postfix sendemail  \
sudo wget curl ethtool iptraf-ng traceroute telnet mariadb-server pwgen \
arping dnsutils dos2unix ethtool sudo iptables postfix iptables-persistent \
build-essential rsyslog gnupg2 zip rar unrar catdoc unzip tar imagemagick ftp \
poppler-utils tnef whois rsync automysqlbackup apache2 imagemagick cifs-utils \
libnet-dns-perl libmailtools-perl php-mail-mime libapache2-mod-php php-common php-redis \
php-gd php-imagick php-imap php-intl php-ldap php-mailparse php-memcached php-cli php-mysql \
php-zip php php-apcu php-bcmath php-curl php-gd php-igbinary 7zip php-mbstring \
php-imagick php-imap php-intl php-xml php-ldap php-mailparse php-memcached \
php-msgpack php-mysql php-zip php-pear php-fpm php-soap
## -x option added to allow in LXC --so that it does not update system clock as it job of host pc.
##echo 'DAEMON_OPTS="-F 1 -x "' >  /etc/default/chrony
systemctl restart chrony

#Disable vim automatic visual mode using mouse
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc

## centos 7 like bash ..for all inteactive 
echo "" >> /etc/bash.bashrc
echo "alias cp='cp -i'" >> /etc/bash.bashrc
echo "alias l.='ls -d .* --color=auto'" >> /etc/bash.bashrc
echo "alias ll='ls -l --color=auto'" >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias mv='mv -i'" >> /etc/bash.bashrc
echo "alias rm='rm -i'" >> /etc/bash.bashrc
echo "export EDITOR=vi" >> /etc/bash.bashrc
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc


##Comment this if you do not want root login via ssh activated using port 7722
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
#sed -i "s/#Port 22/Port 7722/g" /etc/ssh/sshd_config
systemctl restart ssh


a2enmod actions > /dev/null 2>&1
a2enmod proxy_fcgi > /dev/null 2>&1
a2enmod alias > /dev/null 2>&1
a2enmod rewrite > /dev/null 2>&1
a2enmod ssl > /dev/null 2>&1
a2enmod actions > /dev/null 2>&1
a2enmod include > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1
a2enmod proxy_http > /dev/null 2>&1

systemctl stop apache2



# Reset
Color_Off='\033[0m'       # Text Reset
On_IRed='\033[0;101m'     # Red

echo $White $On_IRed 
echo "IS THE HOSTNAME CORRECT !!! : "
 hostname -f
echo "IS DATE AND TIME CORRECT !!! : ";
 date
echo "IF NOT SET IT PROPERLY SET IT."
echo "...............................";
echo $Color_Off

