#!/bin/bash
source ./func.inc

########################################################################
# START OF PROGRAM
########################################################################
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

check_sanity
if [ -f "./config/install.conf" ]; then
	#apt-get -q -y update
	#check_install nano nano
	nano ./config/install.conf
fi

[ -r ./config/install.conf ] && . ./config/install.conf

if [ "$CPUCORES" = "detect" ]; then
	CPUCORES=`grep -c processor //proc/cpuinfo`
fi

if [ "$USER" = "changeme" ]; then
	die "User changeme is not allowed,please change USER in install.conf"
fi

case "$1" in

	base)
		update_upgrade
		remove_unneeded
		install_exim4
		install_nano
		install_dropbear $SSH_PORT
		#install_iptables $SSH_PORT
		install_syslogd
		;;
	lvnmp)
		install_varnish
		install_nginx
		conf_nginx
		install_mysql
		conf_mysql
		install_php5
		conf_php5
		conf_varnish
		;;
	domain)
		install_domain $DOMAIN $WOD
		;;
		
	*)
        echo 'Usage:' `basename $0` '[option] [argument]'
        echo 'Available options (in recomended order):'
        echo '  - base'
		echo '	- lvnmp'
        echo '  - domain'
        echo '  '
        ;;
esac