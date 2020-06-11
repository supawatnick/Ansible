Create CG, snapshot, snapmirror DC ke DRC, clone volume change serial number, map to host
# ansible-playbook create_cgsnap.yaml
 

Unmap volume, Delete cloned volume on DRC, delete snapshot on DC.
# ansible-playbook delete_cgsnap.yaml
 

Paralel kita buatkan 2 buah script untuk os untuk mount/umount serta start dan stop db.
File mountandstartdb.sh & umountandstopdb.sh

(masih perlu di testing, dan pastikan ssh public key ansible server sudah ditambahan agar passwordless)

