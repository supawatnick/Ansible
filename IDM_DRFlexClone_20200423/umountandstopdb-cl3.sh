#stop DB
ssh  root@192.168.72.57 /u01/script/oraclestop.sh

#umount  FS
ssh  root@192.168.72.57 umount -l /ctlfile
ssh  root@192.168.72.57 umount -l /datafile
ssh  root@192.168.72.57 umount -l /index01
ssh  root@192.168.72.57 umount -l /logfile
ssh  root@192.168.72.57 umount -l /undo
ssh  root@192.168.72.57 umount -l /datafile02
ssh  root@192.168.72.57 umount -l /datafile03
ssh  root@192.168.72.57 umount -l /datafile04
ssh  root@192.168.72.57 umount -l /archive01

