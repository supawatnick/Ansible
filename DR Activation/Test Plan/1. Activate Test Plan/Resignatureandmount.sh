#!/bin/bash
## GET VAR FROM VARS FILE ###
esx_drhostname=`cat vars.yaml | shyaml get-value esx_drhostname`
esx_drusername=`cat vars.yaml | shyaml get-value esx_drusername`
esx_iscsi_hba=`cat vars.yaml | shyaml get-value esx_iscsi_hba`

## RESCAN DEVICE ##
ssh $esx_drusername@$esx_drhostname "esxcfg-rescan $esx_iscsi_hba"

## DETECTING VMFS UUID TO RESIGNATURE ###
ssh $esx_drusername@$esx_drhostname "esxcli storage vmfs snapshot list | grep VMFS" > vmfsuuid.list


FILEIN=vmfsuuid.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'`
echo $LOOPS
COUNT=1

## LOOP TO RESIGNATURE ALL DEVICE###
while [ $COUNT -le $LOOPS ]
do
VMFS_UUID=`head -$COUNT $FILEIN |tail -1|awk '{print $3}'`
ssh $esx_drusername@$esx_drhostname "esxcli storage vmfs snapshot resignature -u" $VMFS_UUID
(( COUNT++ ))
done

# Cleanup File
rm vmfsuuid.list

## RESCAN DEVICE ##
ssh $esx_drusername@$esx_drhostname "esxcfg-rescan $esx_iscsi_hba"