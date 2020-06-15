#!/bin/bash
# Need to install shyaml

# Get DR volume name from vars.yaml ###

ontap_drhostname=`cat vars.yaml | shyaml get-value ontap_drhostname`
ontap_drusername=`cat vars.yaml | shyaml get-value ontap_drusername`
ontap_drvserver=`cat vars.yaml | shyaml get-value ontap_drvserver`

lun show -vserver svm2 -path /vol/clone* > lun_clone.list

FILEIN=lun_clone.list
LOOPS=`wc -l $FILEIN |awk '{print $2}'`
echo Found $LOOPS Clone LUN
COUNT=1


echo "ontap_cloneluns:" > lun_clone.yaml
while [ $COUNT -le $LOOPS ]
do
LUN_CLONE=`head -$COUNT $FILEIN |tail -1|awk '{print $2}'`
echo " - " $LUN_CLONE >> lun_clone.yaml
(( COUNT++ ))
done