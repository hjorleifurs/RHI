#!/bin/sh

# Log.io harvester 
# 

############ PATH ####################
#put your path here if you need to
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

export PATH

########## CLIENT and SERVER ####################
#If you want to you can have more clients, i.e. client1, client2 etc
#and then use those in your start script. That way you can have more
#than one node on the same server

#change the client to what you want to appear as a client name
client=`uname -n`

#change the server if it is not your localhost
server='localhost'

export client server

###############################################

status() {
	#Check if we are already running
	RUNNING=`ps -ef|grep -T "printf \"+log" | grep -v grep | awk '{print $2}'`
	if [ "$RUNNING" = "" ]
		then
			echo ${client} harvester is not running
		else
			echo ${client} harvester is running
                        ps -ef|grep -F "printf \"+log" | grep -v grep
			exit
	fi
}	

start() {

status

echo -e | tail -f /var/log/messages | stdbuf -o0  awk -v client=${client} -v logfile=messages '{printf "+log|"client"|"logfile"|info|"; print; printf "\r\n"}' | nc ${server} 28777 &
echo -e | tail -f /var/log/secure | stdbuf -o0  awk -v client=${client} -v logfile=secure '{printf "+log|"client"|"logfile"|info|"; print; printf "\r\n"}' | nc ${server} 28777 &

echo -e | tail -f /var/log/nginx/access.log | stdbuf -o0  awk -v client=${client} -v logfile=nginx '{printf "+log|"client"|"logfile"|info|"; print; printf "\r\n"}' | nc ${server} 28777 &
echo -e | tail -f /var/log/nginx/error.log | stdbuf -o0  awk -v client=${client} -v logfile=nginx '{printf "+log|"client"|"logfile"|info|"; print; printf "\r\n"}' | nc ${server} 28777 &

status

}

stop() {
	echo Stopping ${client} harvester
        PIDS=`ps -ef|grep -F "printf \"+log" | grep -v grep | awk '{print $2}'`
        echo $PIDS
        for i in $PIDS
            do
                echo $i | xargs kill -9
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
