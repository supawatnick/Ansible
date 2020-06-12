#!/bin/bash
## GET VAR FROM VARS FILE ###
esx_drhostname=`cat vars.yaml | shyaml get-value esx_drhostname`
esx_drusername=`cat vars.yaml | shyaml get-value esx_drusername`

## DETECTING VM ID ###
ssh $esx_drusername@$esx_drhostname "vim-cmd vmsvc/getallvms | grep snap" > getallvms.list
FILEIN=getallvms.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'`
echo $LOOPS
COUNT=1

## LOOP TO POWER ON VM ###
while [ $COUNT -le $LOOPS ]
do
VM_ID=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`
ssh $esx_drusername@$esx_drhostname "vim-cmd vmsvc/power.on" $VM_ID
(( COUNT++ ))
done

## CLEAN DATA FILE ##
rm getallvms.list