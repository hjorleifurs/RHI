#!/bin/sh

#Check if connections are to many
#2013-09-18 hs@hi.is

PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

STATUS=`curl -s http://localhost/nginx_status | grep connections | awk '{print $3}'`

OK=10
WARNING=20
#CRITICAL=20 #Not needed since we just more than warning, see below

# Check if OK
if [ $STATUS -lt $OK ]
	then
		echo Nginx connections are OK
                echo "Active connections: $STATUS"
		exit 0
fi

# Check if to send out a warning
if [ $STATUS -gt $OK ] && [ $STATUS -le $WARNING ]
	then
		echo Nginx WARNING
		echo "Active connections: $STATUS"
		exit 1
fi

# Oh shit...
if [ $STATUS -gt $WARNING ]
	then
		echo Nginx CRITICAL
                echo "Active connections: $STATUS"
		exit 2
fi

