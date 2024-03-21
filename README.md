Задание:

• добавить в Vagrantfile еще дисков
• собрать R0/R5/R10 на выбор
• прописать собранный рейд в конф, чтобы рейд собирался при загрузке
• сломать/починить raid 
• создать GPT раздел и 5 партиций и смонтировать их на диск.

*Vagrantfile, который сразу собирает систему с подключенным рейдом и смонтированными разделами. После перезагрузки стенда разделы должны автоматически примонтироваться.

**lsblk** До создания рейда:
   
    ##################################################
     mdadm: NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    mdadm: sda      8:0    0   40G  0 disk
    mdadm: └─sda1   8:1    0   40G  0 part /
    mdadm: sdb      8:16   0  250M  0 disk
    mdadm: sdc      8:32   0  250M  0 disk
    mdadm: sdd      8:48   0  250M  0 disk
    mdadm: sde      8:64   0  250M  0 disk
    mdadm: sdf      8:80   0  250M  0 disk
    
**lsblk** После создания рейда:

    ######################################
    mdadm: NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
    mdadm: sda           8:0    0    40G  0 disk
    mdadm: └─sda1        8:1    0    40G  0 part  /
    mdadm: sdb           8:16   0   250M  0 disk
    mdadm: └─md100       9:100  0   744M  0 raid6
    mdadm:   ├─md100p1 259:0    0   147M  0 md    /raid/part1
    mdadm:   ├─md100p2 259:1    0 148.5M  0 md    /raid/part2
    mdadm:   ├─md100p3 259:2    0   150M  0 md    /raid/part3
    mdadm:   ├─md100p4 259:3    0 148.5M  0 md    /raid/part4
    mdadm:   └─md100p5 259:4    0   147M  0 md    /raid/part5
    mdadm: sdc           8:32   0   250M  0 disk
    mdadm: └─md100       9:100  0   744M  0 raid6
    mdadm:   ├─md100p1 259:0    0   147M  0 md    /raid/part1
    mdadm:   ├─md100p2 259:1    0 148.5M  0 md    /raid/part2
    mdadm:   ├─md100p3 259:2    0   150M  0 md    /raid/part3
    mdadm:   ├─md100p4 259:3    0 148.5M  0 md    /raid/part4
    mdadm:   └─md100p5 259:4    0   147M  0 md    /raid/part5
    mdadm: sdd           8:48   0   250M  0 disk
    mdadm: └─md100       9:100  0   744M  0 raid6
    mdadm:   ├─md100p1 259:0    0   147M  0 md    /raid/part1
    mdadm:   ├─md100p2 259:1    0 148.5M  0 md    /raid/part2
    mdadm:   ├─md100p3 259:2    0   150M  0 md    /raid/part3
    mdadm:   ├─md100p4 259:3    0 148.5M  0 md    /raid/part4
    mdadm:   └─md100p5 259:4    0   147M  0 md    /raid/part5
    mdadm: sde           8:64   0   250M  0 disk
    mdadm: └─md100       9:100  0   744M  0 raid6
    mdadm:   ├─md100p1 259:0    0   147M  0 md    /raid/part1
    mdadm:   ├─md100p2 259:1    0 148.5M  0 md    /raid/part2
    mdadm:   ├─md100p3 259:2    0   150M  0 md    /raid/part3
    mdadm:   ├─md100p4 259:3    0 148.5M  0 md    /raid/part4
    mdadm:   └─md100p5 259:4    0   147M  0 md    /raid/part5
    mdadm: sdf           8:80   0   250M  0 disk
    mdadm: └─md100       9:100  0   744M  0 raid6
    mdadm:   ├─md100p1 259:0    0   147M  0 md    /raid/part1
    mdadm:   ├─md100p2 259:1    0 148.5M  0 md    /raid/part2
    mdadm:   ├─md100p3 259:2    0   150M  0 md    /raid/part3
    mdadm:   ├─md100p4 259:3    0 148.5M  0 md    /raid/part4
    mdadm:   └─md100p5 259:4    0   147M  0 md    /raid/part5

    
    **fstab**:
    mdadm: #
    mdadm: # /etc/fstab
    mdadm: # Created by anaconda on Thu Apr 30 22:04:55 2020
    mdadm: #
    mdadm: # Accessible filesystems, by reference, are maintained under '/dev/disk'
    mdadm: # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    mdadm: #
    mdadm: UUID=1c419d6c-5064-4a2b-953c-05b2c67edb15 /                       xfs     defaults        0 0
    mdadm: /swapfile none swap defaults 0 0
    mdadm: #VAGRANT-BEGIN
    mdadm: # The contents below are automatically generated by Vagrant. Do not modify.
    mdadm: #VAGRANT-END
    mdadm: /dev/md100p1 /raid/part1 ext4 defaults 0 1
    mdadm: /dev/md100p2 /raid/part2 ext4 defaults 0 1
    mdadm: /dev/md100p3 /raid/part3 ext4 defaults 0 1
    mdadm: /dev/md100p4 /raid/part4 ext4 defaults 0 1
    mdadm: /dev/md100p5 /raid/part5 ext4 defaults 0 1

    
