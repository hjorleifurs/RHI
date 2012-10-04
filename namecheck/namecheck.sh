#!/bin/sh


FILE=$1

exec<$FILE

while read line
do
FIELDS=`echo "$line" |awk '{print NF}'`
#echo $FIELDS
echo
if [ $FIELDS -lt 4 ] || [ $FIELDS -gt 6 ]
then
	echo there is something wrong
else
if [ $FIELDS -eq 4 ]
then
	#echo there are $FIELDS fields in the line
	NAME=`echo $line |awk '{print $2,$3}'`
	echo name is $NAME
	NAME1=`echo $NAME | awk '{print $1}'`
        NAME2=`echo $NAME | awk '{print $2}'`


elif [ $FIELDS -eq 5 ]
then
	#echo there are 5 fields in the line
	#echo then I will do somethng else
	NAME=`echo $line | awk '{print $2,$3,$4}'`
	echo name is $NAME
	NAME1=`echo $NAME | awk '{print $1}'`
	NAME2=`echo $NAME | awk '{print $2}'`
	NAME3=`echo $NAME | awk '{print $3}'`
	echo first name is $NAME1
	echo 2nd name is $NAME2  
	INITIAL=`echo $NAME2 | awk '{print substr($0,1,1)}'`
	echo INITIAL is $INITIAL
	echo 3rd name is $NAME3
	
else
	#echo there are $FIELDS fields in this line and that is a lot
	NAME=`echo $line | awk '{print $2,$3,$4,$5}'`
	echo name is $NAME
	
fi
fi
done 



