#!/bin/bash
#-----------------------------------------------------------------------------------------------------
#
# + Script Bash untuk menginstal kernel Linux versi 5.15.5 di Kali Linux
# + Dibuat oleh: Rofi (Fixploit03)
# + Lisensi: MIT
# + GitHub: https://github.com/fixploit03/kernel-linux-5.15.5
#
#-----------------------------------------------------------------------------------------------------

# Pastikan dialog ada
if ! command -v dialog &> /dev/null; then
    echo "[-] dialog belum terinstal. Install dulu dengan: sudo apt install dialog"
    exit 1
fi

# Cek apakah root
if [[ $EUID -ne 0 ]]; then
    dialog --title "ERROR" --msgbox "Script ini harus dijalankan sebagai root!\n\nCoba: sudo bash $0" 10 50
    exit 1
fi

# Banner awal
dialog --title "Installer Kernel Linux 5.15.5" --msgbox "\
Script ini dibuat untuk memperbaiki masalah Wi-Fi TP-LINK TL-WN722N V2/V3.\n\
Kernel Linux versi 5.15.5 lebih kompatibel dengan chipset Realtek RTL8188EUS.\n\n\
Dibuat oleh: Rofi (Fixploit03)\nLisensi: MIT" 15 60

# Tanya mau instal atau tidak
dialog --title "Konfirmasi" --yesno "Apakah Anda ingin menginstal kernel Linux versi 5.15.5?" 8 60
jawab=$?
if [[ $jawab -ne 0 ]]; then
    dialog --title "Keluar" --msgbox "Proses dibatalkan." 6 40
    clear
    exit 0
fi

# Cek apakah kernel sudah terinstal
dialog --infobox "Mengecek kernel Linux 5.15.5..." 5 40
sleep 2
if dpkg -l | grep -q "linux-image-unsigned-5.15.5"; then
    dialog --title "Info" --msgbox "Kernel Linux versi 5.15.5 sudah terinstal.\nProses instalasi dibatalkan." 8 50
    clear
    exit 0
fi

# Cek koneksi internet
dialog --infobox "Mengecek koneksi internet..." 5 40
sleep 2
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    dialog --title "ERROR" --msgbox "Tidak ada koneksi internet!\nPastikan koneksi aktif untuk melanjutkan." 8 50
    clear
    exit 1
fi

# File DEB kernel
file_deb=(
    "http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb"
    "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-image-unsigned-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
    "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-modules-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
    "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505_5.15.5-051505.202111250933_all.deb"
    "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
)

# Download file DEB
(
    i=0
    for url in "${file_deb[@]}"; do
        i=$((i+1))
        nama_file=$(basename "$url")
        echo "XXX"
        echo "$((i*20))"
        echo "Mendownload: $nama_file"
        echo "XXX"
        wget -q --show-progress "$url"
    done
) | dialog --title "Download File DEB" --gauge "Sedang mendownload file..." 10 60 0

# Instalasi file DEB
dialog --infobox "Menginstal kernel Linux 5.15.5..." 5 50
sleep 2
if ! dpkg -i *.deb; then
    apt --fix-broken install -y
    dpkg -i *.deb || {
        dialog --title "ERROR" --msgbox "Instalasi kernel gagal.\nSilakan cek manual." 8 50
        clear
        exit 1
    }
fi

dialog --title "Sukses" --msgbox "Kernel Linux 5.15.5 berhasil diinstal." 8 50

# Update GRUB
dialog --infobox "Memperbarui konfigurasi GRUB..." 5 50
sleep 2
update-grub || {
    dialog --title "ERROR" --msgbox "Gagal memperbarui GRUB." 6 40
    clear
    exit 1
}

# Load driver WiFi
dialog --infobox "Memuat driver WiFi 8188eu..." 5 50
sleep 2
if ! modprobe 8188eu; then
    dialog --title "ERROR" --msgbox "Gagal memuat driver 8188eu.\nCoba reboot lalu jalankan manual: modprobe 8188eu" 8 60
    clear
    exit 1
fi

# Tanya reboot
dialog --title "Reboot" --yesno "Apakah Anda ingin me-reboot sistem sekarang?" 7 50
if [[ $? -eq 0 ]]; then
    reboot
else
    dialog --title "Selesai" --msgbox "Instalasi selesai tanpa reboot.\nReboot manual agar kernel aktif." 8 60
    clear
    exit 0
fi
        exit 1
fi

# Menampilkan banner
clear
echo ""
sleep 0.1
echo -e "${p}+----------------------------------------------------------------------------------------------+${r}"
sleep 0.1
echo -e "${p}|                                                                                              |${r}"
sleep 0.1
echo -e "${p}| ${b}██${p}╗  ${b}██${p}╗${b}███████${p}╗${b}██████${p}╗ ${b}███${p}╗   ${b}██${p}╗${b}███████${p}╗${b}██${p}╗         ${b}██${p}╗     ${b}██${p}╗${b}███${p}╗   ${b}██${p}╗${b}██${p}╗   ${b}██${p}╗${b}██${p}╗  ${b}██${p}╗ |${r}"
sleep 0.1
echo -e "${p}| ${b}██${p}║ ${b}██${p}╔╝${b}██${p}╔════╝${b}██${p}╔══${b}██${p}╗${b}████${p}╗  ${b}██${p}║${b}██${p}╔════╝${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}████${p}╗  ${b}██${p}║${b}██${p}║   ${b}██${p}║╚${b}██${p}╗${b}██${p}╔╝ |${r}"
sleep 0.1
echo -e "${p}| ${b}█████${p}╔╝ ${b}█████${p}╗  ${b}██████${p}╔╝${b}██${p}╔${b}██${p}╗ ${b}██${p}║${b}█████${p}╗  ${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}██${p}╔${b}██${p}╗ ${b}██${p}║${b}██${p}║   ${b}██${p}║ ╚${b}███${p}╔╝  |${r}"
sleep 0.1
echo -e "${p}| ${b}██${p}╔═${b}██${p}╗ ${b}██${p}╔══╝  ${b}██${p}╔══${b}██${p}╗${b}██${p}║╚${b}██${p}╗${b}██${p}║${b}██${p}╔══╝  ${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}██${p}║╚${b}██${p}╗${b}██${p}║${b}██${p}║   ${b}██${p}║ ${b}██${p}╔${b}██${p}╗  |${r}"
sleep 0.1
echo -e "${p}| ${b}██${p}║  ${b}██${p}╗${b}███████${p}╗${b}██${p}║  ${b}██${p}║${b}██${p}║ ╚${b}████${p}║${b}███████${p}╗${b}███████${p}╗    ${b}███████${p}╗${b}██${p}║${b}██${p}║ ╚${b}████${p}║╚${b}██████${p}╔╝${b}██${p}╔╝ ${b}██${p}╗ |${r}"
sleep 0.1
echo -e "${p}| ${p}╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ |${r}"
sleep 0.1
echo -e "${p}|                                                                                ${h}Versi: ${p}5.15.5 |${r}"
sleep 0.1
echo -e "${p}|                                                               ${h}Dibuat oleh: ${p}Rofi (Fixploit03) |${r}"
sleep 0.1
echo -e "${p}|                                                                                              |${r}"
sleep 0.1
echo -e "${p}+----------------------------------------------------------------------------------------------+${r}"
sleep 0.1
echo ""
sleep 0.1

# Nanya mau instal apa kaga
read -p "${ib}[#] ${ip}Apakah Anda ingin menginstal kernel linux versi 5.15.5 [Y/n]: " nanya

# Iya
if [[ "${nanya}" == "y" || "${nanya}" == "Y" ]]; then
        :
# Kaga
elif [[ "${nanya}" == "n" || "${nanya}" == "N" ]]; then
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 0
# Inputan salah
else
        echo -e "${m}[-] ${p}Masukkan tidak valid. Harap masukkan Y/n.${r}"
        exit 1
fi

# Cek apakah kernel linux versi 5.15.5 sudah terinstal apa belum
echo -e "${b}[*] ${p}Mengecek apakah kernel linux versi 5.15.5 sudah terinstal...${r}"
sleep 3
if dpkg -l | grep -q "linux-image-unsigned-5.15.5"; then
        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 sudah terinstal.${r}"
        echo -e "${b}[*] ${p}Proses instalasi dibatalkan.${r}"
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 1
else
        echo -e "${m}[-] ${p}Kernel linux versi 5.15.5 belum terinstal.${r}"
        echo -e "${b}[*] ${p}Menginstal kernel linux versi 5.15.5...${r}"
        sleep 3
fi

# Cek koneksi internet
echo -e "${b}[*] ${p}Mengecek koneksi internet Anda...${r}"
sleep 3
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${h}[+] ${p}Anda memiliki koneksi internet.${r}"
else
    echo -e "${m}[-] ${p}Anda tidak memliki koneksi internet. Pastikan Anda memiliki koneksi internet untuk menggunakan script ini.${r}"
    exit 1
fi


# File deb kernel 5.15.5
file_deb=(
        "http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-image-unsigned-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-modules-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505_5.15.5-051505.202111250933_all.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
)

# Mendownload semua file DEB yang dibutuhkan
echo -e "${b}[*] ${p}Mendownload semua file DEB yang dibutuhkan...${r}"
sleep 3

for download_file in "${file_deb[@]}"; do
        nama_file=$(basename "${download_file}")
        echo -e "${b}[*] ${p}Mendownload file DEB '${nama_file}'...${r}"
        sleep 3
        # Berhasil
        if wget -c "${download_file}"; then
                echo -e "${h}[+] ${p}File DEB '${nama_file}'. berhasil didownload.${r}"
        # Gagal
        else
                echo -e "${m}[-] ${p}Gagal mendownload file DEB '${nama_file}'.${r}"
                exit 1
        fi
done
echo -e "${h}[+] ${p}Semua file DEB yang dibutuhkan berhasil didownload.${r}"

# Menginstal semua file DEB yang dibutuhkan
echo -e "${b}[*] ${p}Menginstal semua file DEB yang dibutuhkan...${r}"
sleep 3
if dpkg -i *.deb; then
        echo -e "${h}[+] ${p}Semua file DEB yang dibutuhkan berhasil diinstal.${r}"
        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 berhasil diinstal.${r}"

else
        echo -e "${m}[-] ${p}Ada file DEB yang gagal diinstal.${r}"
        echo -e "${b}[*] ${p}Memperbaiki dependensi yang rusak...${r}"
        sleep 3
        if apt --fix-broken install -y; then
                echo -e "${h}[+] ${p}Dependensi berhasil diperbaiki.${r}"
                echo -e "${b}[*] ${p}Mengulang instalasi file DEB...${r}"
                if dpkg -i *.deb; then
                        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 berhasil diinstal setelah perbaikan.${r}"
                else
                        echo -e "${m}[-] ${p}Masih ada error saat instalasi kernel. Silakan cek manual.${r}"
                        exit 1
                fi
        else
                echo -e "${m}[-] ${p}Gagal memperbaiki dependensi. Silakan cek manual.${r}"
                echo -e "${h}[-] ${p}Gagal menginstal Kernel linux versi 5.15.5.${r}"
                exit 1
        fi
fi

# Memperbarui konfigurasi GRUB
echo -e "${b}[*] ${p}Memperbarui konfigurasi GRUB...${r}"
sleep 3
# Berhasil
if update-grub; then
        echo -e "${h}[+] ${p}Konfigurasi GRUB berhasil diperbarui.${r}"
# Gagal
else
        echo -e "${m}[-] ${p}Gagal memperbarui konfigurasi GRUB.${r}"
        exit 1
fi

# Memuat modul driver WiFi (TP-Link TL-WN722N v2/v3 - Realtek 8188eu)
echo -e "${b}[*] ${p}Memuat modul driver WiFi (8188eu untuk TL-WN722N v2/v3)...${r}"
sleep 3
if modprobe 8188eu; then
        echo -e "${h}[+] ${p}Driver 8188eu berhasil dimuat.${r}"
        if lsmod | grep -q 8188eu; then
                echo -e "${h}[+] ${p}Driver 8188eu aktif dan terdeteksi oleh kernel.${r}"
        else
                echo -e "${m}[-] ${p}Driver 8188eu tidak muncul di daftar modul aktif.${r}"
                echo -e "${b}[*] ${p}Silakan cek manual dengan perintah: ${h}'lsmod | grep 8188eu'${r}"
                exit 1
        fi
else
        echo -e "${m}[-] ${p}Gagal memuat driver 8188eu.${r}"
        echo -e "${b}[*] ${p}Coba reboot sistem Anda lalu jalankan manual: ${h}'modprobe 8188eu'${r}"
        exit 1
fi

# Nanya mau reboot apa kaga
read -p "${ib}[#] ${ip}Apakah Anda ingin me-reboot sistem Anda? [Y/n]: " nanya_reboot

# Iya
if [[ "${nanya_reboot}" == "y" || "${nanya_reboot}" == "Y" ]]; then
        reboot
# Kaga
elif [[ "${nanya_reboot}" == "n" || "${nanya_reboot}" == "N" ]]; then
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 0
# Inputan salah
else
        echo -e "${m}[-] ${p}Masukkan tidak valid. Harap masukkan Y/n.${r}"
        exit 1
fi

# Selesai
#
# Semoga bermanfaat ^_^
