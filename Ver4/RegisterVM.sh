#!/bin/bash
## GET VAR FROM VARS FILE ###
esx_drhostname=`cat vars.yaml | shyaml get-value esx_drhostname`
esx_drusername=`cat vars.yaml | shyaml get-value esx_drusername`

## DETECTING VMX FILE ###
ssh $esx_drusername@$esx_drhostname "ls /vmfs/volumes/snap*/*/*.vmx" > vmxfile.list

FILEIN=vmxfile.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'`
echo $LOOPS
COUNT=1

## LOOP TO REGISTER VMX ON ALL DEVICE###
while [ $COUNT -le $LOOPS ]
do
VMX_FILE=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`
ssh $esx_drusername@$esx_drhostname "vim-cmd solo/registervm " $VMX_FILE
(( COUNT++ ))
done

rm vmxfile.list