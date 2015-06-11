#!/bin/sh

# Log.io harvester 
# 

############ PATH ####################
#put your path here if you need to
PATH=/usr/bin:/usr/lib64/qt-3.3/bin:/usr/pgsql-9.4/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

########## CLIENT and SERVER ####################
#If you want to you can have more clients, i.e. client1, client2 etc
#and then use those in your start script. That way you can have more
#than one node on the same server

client=`uname -n`
server='PUT_YOUR_SERVER_NAME_HERE'
logfile1='/var/log/messages'
logfile2='/var/log/secure'
#logfile3='/full/path/to/your/logfile'

###################################

status() {
	#Check if we are already running
	RUNNING=`ps -ef|grep -T ugla_throun | grep -v grep | awk '{print $2}'`
	if [ "$RUNNING" = "" ]
		then
			echo $0 is not running
		else
			echo $0 is running
			exit
	fi
}	

start() {

status

#Change to the logfile you want to monitor and make new lines as needed for every logfile
echo -e | tail -f ${logfile1} | stdbuf -o0  awk  '{printf "+log|${client}|messages|info|"; print; printf "\r\n"}' | nc ${server} 28777 &
echo -e | tail -f ${logfile2} | stdbuf -o0  awk  '{printf "+log|${client}|messages|info|"; print; printf "\r\n"}' | nc ${server} 28777 &
#echo -e | tail -f ${logfile3} | stdbuf -o0  awk  '{printf "+log|${client}|messages|info|"; print; printf "\r\n"}' | nc ${server} 28777 &

echo $client harvester has started
}

stop() {
	echo Stopping ${client} harvester
	for PID in `ps -ef|grep -T ugla_throun | grep -v grep | awk '{print $2}'`
		do
			kill -9 $PID
		done
	echo ${client} harvester has been stopped
}


case "$1" in
	start) start ;;
	stop) stop ;;
	restart) stop
		 start ;;
	status) status ;;
	
	*) echo "Usage: $0 start|stop|restart|status";;
esac
