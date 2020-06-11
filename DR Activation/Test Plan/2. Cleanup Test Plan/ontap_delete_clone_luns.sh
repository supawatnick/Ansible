####Offline Clone LUNs
# Get DR Clone LUNs name from vars.yaml ###
cat vars.yaml | shyaml get-value ontap_cloneluns| awk '{print $2}' > lun_dest.list
cat vars.yaml | shyaml get-value ontap_drvolumes| awk '{print $2}' > vol_dest.list
ontap_drhostname=`cat vars.yaml | shyaml get-value ontap_drhostname`
ontap_drusername=`cat vars.yaml | shyaml get-value ontap_drusername`
ontap_drvserver=`cat vars.yaml | shyaml get-value ontap_drvserver`
ontap_cloneprefix=`cat vars.yaml | shyaml get-value ontap_cloneprefix`


# Create Loop following Clone LUNs and VOLUMEs
FILEIN=lun_dest.list
​VOLFILE=vol_dest.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'` ## Count no. of clone LUNs for loop
echo Found $LOOPS "Clone LUNs"
COUNT=1

## LOOP TO Offline and Delete CLONE LUNS and VOLUMES###
while [ $COUNT -le $LOOPS ]
do
LUN_DEST=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`  ## Put Cline LUNs dest to LUN_DEST
VOL_DEST=`head -$COUNT $VOLFILE |tail -1|awk '{print $1}'`
#echo y | ssh $ontap_drusername@$ontap_drhostname "lun offline -vserver $ontap_drvserver -path $LUN_DEST"
#sleep 3
#echo y | ssh $ontap_drusername@$ontap_drhostname "lun delete -vserver $ontap_drvserver -path $LUN_DEST"
#sleep 3
echo y | ssh $ontap_drusername@$ontap_drhostname "vol offline -vserver $ontap_drvserver -volume $ontap_cloneprefix$VOL_DEST"
sleep 3
echo y | ssh $ontap_drusername@$ontap_drhostname "vol delete -vserver $ontap_drvserver -volume $ontap_cloneprefix$VOL_DEST"
sleep 3
(( COUNT++ ))
done

rm lun_dest.list
rm vol_dest.list