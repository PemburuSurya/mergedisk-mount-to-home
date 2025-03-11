# Merge Disk and Mount to /home

Skrip ini digunakan untuk menggabungkan beberapa disk menjadi satu Logical Volume (LVM) dan memindahkan direktori `/home` ke volume tersebut. Skrip ini cocok untuk sistem Linux yang membutuhkan penyimpanan besar di `/home`.

---

## **Cara Menggunakan**

1. **Merge Disk & Mount to Home 500GB**
   ```bash
   git clone https://github.com/PemburuSurya/mergedisk-mount-to-home.git && cd mergedisk-mount-to-home && chmod +x 500G.sh && ./500G.sh
