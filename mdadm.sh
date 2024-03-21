#!/bin/bash

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
#install mdadm
yum install -y mdadm smartmontools hdparm gdisk
#информация о блочных устройствах
lsblk
df -h
lshw
lsscsi

sudo lshw -short | grep disk
sudo fdisk -l

#Зануление  суперблоков
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
#создание рейда
# -l level raid (example,6,RAID 6)
#md100 имя выбирается на свое усмотрение
#-n count device
sudo mdadm --create --verbose /dev/md100 -l 6 -n 5 /dev/sd{b,c,d,e,f}
#Проверим рейд
sudo cat /proc/mdstat
sudo mdadm -D /dev/md100


##############################################
#Создание конфигурационного файла mdadm.conf##
##############################################
#Информация
mdadm --detail --scan --verbose

#Создание файла mdadm.conf
mkdir  /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
cp /etc/mdadm/mdadm.conf /vagrant

#################################
# Сломать/починить RAID         #
#################################
eo 
echo "Ломает рейд"
#искусственно “зафейлим” одно из блочных устройств командной
mdadm /dev/md100 --fail /dev/sde
mdadm -D /dev/md100
#Удалим “сломанный” диск из массива:
mdadm /dev/md100 --remove /dev/sde
#добавить диск в RAID
mdadm /dev/md100 --add /dev/sde
#Диск должен пройти стадию rebuilding
cat /proc/mdstat
mdadm -D /dev/md100


#######################################
#Создать GPT раздел, пять партиций и смонтировать их на диск
#######################################
#Создаем раздел GPT на RAID
parted -s /dev/md100 mklabel gpt
#Создаем партиции

parted /dev/md100 mkpart primary ext4 0% 20%
parted /dev/md100 mkpart primary ext4 20% 40%
parted /dev/md100 mkpart primary ext4 40% 60%
parted /dev/md100 mkpart primary ext4 60% 80%
parted /dev/md100 mkpart primary ext4 80% 100%

#Далее можно создать на этих партициях ФС(файловая система)

for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md100p$i; done


#смонтировать их по каталогам

mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md100p$i /raid/part$i; 
#перезагрузки стенда разделы должны автоматически примонтироваться
echo /dev/md100p$i /raid/part$i ext4 defaults 0 1 >> /etc/fstab;
done

lsblk
df -h
cat /etc/fstab
cat /etc/mdadm/mdadm.conf