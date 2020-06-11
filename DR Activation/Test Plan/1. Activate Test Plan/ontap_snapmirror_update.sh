#!/bin/bash
# Need to install shyaml

# Get DR volume name from vars.yaml ###
cat vars.yaml | shyaml get-value ontap_drvolumes| awk '{print $2}' > vol_dest.list
ontap_drhostname=`cat vars.yaml | shyaml get-value ontap_drhostname`
ontap_drusername=`cat vars.yaml | shyaml get-value ontap_drusername`
ontap_drvserver=`cat vars.yaml | shyaml get-value ontap_drvserver`

# Create Loop following volumes no.
FILEIN=vol_dest.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'` ## Count no. of volume for loop
echo $LOOPS "RELATION TO EXECUTE"
COUNT=1

## LOOP TO REGISTER VMX ON ALL DEVICE ###
while [ $COUNT -le $LOOPS ]
do
VOL_DEST=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`  ## Put Volume dest to VOL_DEST
ssh $ontap_drusername@$ontap_drhostname "snapmirror update $ontap_drvserver:$VOL_DEST"
sleep 3
(( COUNT++ ))
done

rm vol_dest.list
