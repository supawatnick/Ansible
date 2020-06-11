#!/bin/bash
FILEIN=logo
LN=`wc -l logo|awk '{print $1}'`

COUNT=1
while [ $COUNT -le $LN ]
do
head -$COUNT $FILEIN |tail -1
sleep 0.1
(( COUNT++ ))
done
