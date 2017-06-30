#!/bin/bash

#deletes the oldest mariadb-bin logs
#2017-06-28 hs

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

#To delete X number of logs then change the first tail number
#3 means that 2 logs will be deleted
LOGFILE=`ls -t /var/lib/mysql/mariadb-bin.* | /usr/bin/tail -3 |head -1 | awk -F"/" '{print $5}'`

#Dont delete if FJOLDI is less than X (FJOLDI=AMOUNT)
FJOLDI=60
BINFILES=`ls /var/lib/mysql/mariadb-bin.* | wc -l`

if [ ${BINFILES} -le ${FJOLDI}  ]
	then
		echo Fjoldi mariadb-bin er $BINFILES
		echo geri ekkert
		exit
fi

#FLUSH LOGS setur það sem er í minni út í nýjasta logginn og byrjar svo á nýjum logg
/usr/bin/mysql -e "FLUSH LOGS;"

#PURGE eyðir svo loggum skv skilgreiningu á LOGFILE hér að ofan
/usr/bin/mysql -e "PURGE BINARY LOGS TO '${LOGFILE}';"


