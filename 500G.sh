#!/bin/bash

# Fungsi untuk mengecek apakah perintah berhasil dijalankan
check_success() {
    if [ $? -eq 0 ]; then
        echo "[SUCCESS] $1"
    else
        echo "[FAILED] $1"
        echo "Skrip dihentikan karena terjadi kegagalan."
        exit 1
    fi
}

# Unmount volumes
echo "Memulai unmount volumes..."
sudo umount /mnt/volume_sgp1_01
check_success "Unmount /mnt/volume_sgp1_01"
sudo umount /mnt/volume_sgp1_02
check_success "Unmount /mnt/volume_sgp1_02"
sudo umount /mnt/volume_sgp1_03
check_success "Unmount /mnt/volume_sgp1_03"
sudo umount /mnt/volume_sgp1_04
check_success "Unmount /mnt/volume_sgp1_04"
sudo umount /mnt/volume_sgp1_05
check_success "Unmount /mnt/volume_sgp1_05"

# Create Physical Volumes
echo "Membuat Physical Volumes..."
sudo pvcreate /dev/sda
check_success "Membuat Physical Volume /dev/sda"
sudo pvcreate /dev/sdb
check_success "Membuat Physical Volume /dev/sdb"
sudo pvcreate /dev/sdc
check_success "Membuat Physical Volume /dev/sdc"
sudo pvcreate /dev/sdd
check_success "Membuat Physical Volume /dev/sdd"
sudo pvcreate /dev/sde
check_success "Membuat Physical Volume /dev/sde"

# Create Volume Group
echo "Membuat Volume Group..."
sudo vgcreate vg_home /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde
check_success "Membuat Volume Group vg_home"

# Create Logical Volume
echo "Membuat Logical Volume..."
sudo lvcreate -l 100%FREE -n lv_home vg_home
check_success "Membuat Logical Volume lv_home"

# Format Logical Volume
echo "Memformat Logical Volume..."
sudo mkfs.ext4 /dev/vg_home/lv_home
check_success "Memformat Logical Volume /dev/vg_home/lv_home"

# Create /home directory
echo "Membuat direktori /home..."
sudo mkdir -p /home
check_success "Membuat direktori /home"

# Mount Logical Volume to /home
echo "Memasang Logical Volume ke /home..."
sudo mount /dev/vg_home/lv_home /home
check_success "Memasang Logical Volume ke /home"

# Sync data from /mnt/home to /home
echo "Menyalin data dari /mnt/home ke /home..."
sudo rsync -avx /mnt/home/ /home/
check_success "Menyalin data dari /mnt/home ke /home"

# Add entry to /etc/fstab
echo "Menambahkan entri ke /etc/fstab..."
echo '/dev/vg_home/lv_home  /home  ext4  defaults  0  2' | sudo tee -a /etc/fstab
check_success "Menambahkan entri ke /etc/fstab"

# Verify the mount
echo "Memverifikasi pemasangan..."
df -h | grep /home
check_success "Memverifikasi pemasangan Logical Volume"

# Pesan akhir
echo "=========================================="
echo "Skrip berhasil dijalankan tanpa kegagalan!"
echo "Logical Volume berhasil dibuat dan dipasang ke /home."
echo "=========================================="
