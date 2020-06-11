#!/bin/bash
## GET VAR FROM VARS FILE ###
esx_drhostname=`cat vars.yaml | shyaml get-value esx_drhostname`
esx_drusername=`cat vars.yaml | shyaml get-value esx_drusername`

ssh $esx_drusername@$esx_drhostname "ls /vmfs/volumes/ | grep snap"  > current_ds.list

FILEIN=current_ds.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'`
echo Found $LOOPS Clone Datastores
COUNT=1


echo "clone_datastore:" > current_ds.yaml

while [ $COUNT -le $LOOPS ]
do
CURRENT_DS=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`
echo " - " $CURRENT_DS >> current_ds.yaml
(( COUNT++ ))
done

#rm current_ds.list