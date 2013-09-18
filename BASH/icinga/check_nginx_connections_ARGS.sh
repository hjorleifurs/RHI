#!/bin/sh

#Check if connections are to many
#2013-09-18 hs@hi.is

PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

STATUS=`curl -s http://localhost/nginx_status | grep connections | awk '{print $3}'`

# Use the icinga/nagios flags -w and -c

# Default values

WARNING=10
CRITICAL=20

export WARNING
export CRITICAL

if [ "$1" = "-w" ] && [ -n $2 ]
        then
                WARNING=$2
                export WARNING
fi

if [ "$3" = "-c" ] && [ -n $4 ]
        then
                CRITICAL=$4
                export CRITICAL
fi

if [ "$1" = "-c" ] && [ -n $2 ]
        then
                CRITICAL=$2
                export CRITICAL
fi

if [ "$3" = "-w" ] && [ -n $4 ]
        then
                WARNING=$4
                export WARNING
fi

if [ $WARNING -ge $CRITICAL ]
	then
		let WARNING=${CRITICAL}-1
		export WARNING
		echo warning is $WARNING
fi

# Now lets do the checks

# Check if OK
if [ $STATUS -le $WARNING ]
	then
		echo Nginx connections are OK
                echo "Active connections: $STATUS"
		exit 0
fi

# Check if to send out a warning
if [ $STATUS -gt $WARNING ] && [ $STATUS -lt $CRITICAL ]
	then
		echo Nginx WARNING
		echo "Active connections: $STATUS"
		exit 1
fi

# Oh shit...
if [ $STATUS -ge $CRITICAL ]
	then
		echo Nginx CRITICAL
                echo "Active connections: $STATUS"
		exit 2
fi

