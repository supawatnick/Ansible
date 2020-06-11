####Offline Clone LUNs
# Get DR Clone LUNs name from vars.yaml ###
cat vars.yaml | shyaml get-value ontap_cloneluns| awk '{print $2}' > lun_dest.list
ontap_drhostname=`cat vars.yaml | shyaml get-value ontap_drhostname`
ontap_drusername=`cat vars.yaml | shyaml get-value ontap_drusername`
ontap_drvserver=`cat vars.yaml | shyaml get-value ontap_drvserver`

# Create Loop following Clone LUNs no.
FILEIN=lun_dest.list
LOOPS=`wc -l $FILEIN |awk '{print $1}'` ## Count no. of clone LUNs for loop
echo Found $LOOPS "Clone LUNs"
COUNT=1

## LOOP TO OFFLINE CLONE LUNS ###
while [ $COUNT -le $LOOPS ]
do
LUN_DEST=`head -$COUNT $FILEIN |tail -1|awk '{print $1}'`  ## Put Cline LUNs dest to LUN_DEST
echo y | ssh $ontap_drusername@$ontap_drhostname "lun offline -vserver $ontap_drvserver -path $LUN_DEST"
sleep 3
(( COUNT++ ))
done

rm lun_dest.list