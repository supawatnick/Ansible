#!/bin/bash
# Need to install shyaml

# Get ONTAP var
ontap_drhostname=`cat vars.yaml | shyaml get-value ontap_drhostname`
ontap_drusername=`cat vars.yaml | shyaml get-value ontap_drusername`
ontap_drvserver=`cat vars.yaml | shyaml get-value ontap_drvserver`

# Get clone LUNs and export to lun_clone.list
ssh $ontap_drusername@$ontap_drhostname "lun show -vserver $ontap_drvserver -path /vol/clone*" > lun_clone.list

# Create loop following no. of LUNs clone
FILEIN=lun_clone.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'`
echo Found $LOOPS Clone LUN
COUNT=1

# Create lun_clone.yaml
echo "ontap_cloneluns:" > lun_clone.yaml
while [ $COUNT -le $LOOPS ]
do
LUN_CLONE=`head -$COUNT $FILEIN |tail -1|awk '{print $2}'`
echo " - " $LUN_CLONE >> lun_clone.yaml
(( COUNT++ ))
done

rm lun_clone.list