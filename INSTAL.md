## Cara Instal

> [!IMPORTANT]
> Pastikan Anda telah menginstal driver untuk adapter Wi-Fi TP-LINK TL-WN722N V2/V3 menggunakan DKMS. Jika belum, silakan jalankan perintah berikut. Jika sudah, langkah ini dapat dilewati.

## 1. Instal Driver Menggunakan DKMS

1. Update repositori dan upgrade sistem Kali Linux:

   ```
   sudo apt update && sudo apt upgrade -y
   sudo apt full-upgrade -y
   ```

2. Instal dependensi yang dibutuhkan:

   ```
   sudo apt install -y dkms build-essential linux-headers-$(uname -r) git
   ```

3. Kloning driver dari GitHub:

   ```
   git clone https://github.com/aircrack-ng/rtl8188eus.git
   ```

4. Pindah ke direktori driver:

   ```
   cd rtl8188eus
   ```
   
5. Blacklist driver bawaan:

   ```
   echo 'blacklist r8188eu' | sudo tee -a /etc/modprobe.d/realtek.conf
   ```

6. Install via DKMS

   ```
   sudo ./dkms-install.sh
   ```

> [!IMPORTANT]
> Jika driver sudah berhasil diinstal, silakan jalankan perintah berikut:

## 2. Instal Kernel Linux 5.15.5

1. Kloning script dari GitHub:
   
   ```
   git clone https://github.com/fixploit03/kernel-linux-5.15.5
   ```

2. Pindah ke direktori script:
   
   ```
   cd kernel-linux-5.15.5
   ```
   
3. Beri izin eksekusi pada script:

   ```
   chmod +x instal_kernel_linux_5.15.5.sh
   ```

4. Instal kernel:

   ```
   sudo ./instal_kernel_linux_5.15.5.sh
   ```


> [!NOTE]  
> Untuk informasi selengkapnya, silakan lihat tutorial video berikut:  
> [https://youtu.be/5qAqG-FzZiQ?si=XzQluGK-IDR0Oetv](https://youtu.be/5qAqG-FzZiQ?si=XzQluGK-IDR0Oetv)
