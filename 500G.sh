#!/bin/bash

# Unmount volumes
sudo umount /mnt/volume_sgp1_01
sudo umount /mnt/volume_sgp1_02
sudo umount /mnt/volume_sgp1_03
sudo umount /mnt/volume_sgp1_04
sudo umount /mnt/volume_sgp1_05

# Create Physical Volumes
sudo pvcreate /dev/sda
sudo pvcreate /dev/sdb
sudo pvcreate /dev/sdc
sudo pvcreate /dev/sdd
sudo pvcreate /dev/sde

# Create Volume Group
sudo vgcreate vg_home /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde

# Create Logical Volume
sudo lvcreate -l 100%FREE -n lv_home vg_home

# Format Logical Volume
sudo mkfs.ext4 /dev/vg_home/lv_home

# Create /home directory and Mount
sudo mkdir /home

# Mount Logical Volume to /home
sudo mount /dev/vg_home/lv_home /home

# Sync data from /mnt/home to /home
sudo rsync -avx /home/ /mnt/home/

# Add entry to /etc/fstab
echo '/dev/vg_home/lv_home  /home  ext4  defaults  0  2' | sudo tee -a /etc/fstab

# Verify the mount
df -h | grep /home

# Pesan akhir
echo "=========================================="
echo "Skrip berhasil dijalankan tanpa kegagalan!"
echo "Logical Volume berhasil dibuat dan dipasang ke /home."
echo "=========================================="
