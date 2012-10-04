#!/bin/sh
#
#Check IP's in /var/log/fail2ban.log that have been banned and ban them again
#but whenever fail2ban is restarted then all the iptables rules are cleared
#This adds them back in based on the logfile and an extra file, yes this is
#a script that has an extra file, but not all scripts do, so you should
#consider yourself lucky to have found this script.
#
#As you will soon discover, then you have to be root to run this script
#and read the importand extra file that this script has.

#Author: Hjörleifur Sveinbjörnsson
#Date: 2012-08-10

Extra_file=/root/ip-banlist


if [ -f $Extra_file ]
then 
tmplist=`grep Ban /var/log/fail2ban.log | awk '{print $7}' | grep -v 192.168 | uniq`
LIST="$tmplist `cat $Extra_file`"
else
LIST=`grep Ban /var/log/fail2ban.log | awk '{print $7}' | grep -v 192.168 | uniq`
fi

IPTABLES_LIST=`iptables -L -n | grep DROP | awk '{print $4}'`
iptables -L -n | grep DROP | awk '{print $4}' | uniq > /tmp/iptables_list

if [ -z "$IPTABLES_LIST" ]
	then
		for i in $LIST
		do
		echo iptables -I fail2ban-SSH 1 -s $i -j DROP
		iptables -I fail2ban-SSH 1 -s $i -j DROP
		done
	else
		for i in $LIST
		do
			CHECK=`grep $i /tmp/iptables_list`
			if [ -z "$CHECK" ]
			then
			echo IP $i was not in iptables_list
			echo iptables -I fail2ban-SSH 1 -s $i -j DROP
			iptables -I fail2ban-SSH 1 -s $i -j DROP
			else 
			echo IP $i is in iptables and that is wunderbar
			fi
		done
fi

#A little cleanup
rm /tmp/iptables_list
