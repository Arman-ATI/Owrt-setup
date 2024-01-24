RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    sleep .5 
fi
echo "Running as root..."
sleep .5
clear
while true; do
    clear
        echo -e "${BLUE}${YELLOW} 1.${NC} ${CYAN}install usb${NC}         ${BLUE}${NC}"
        echo -e "${BLUE}${YELLOW} 2.${NC} ${CYAN}install needed pkgs${NC}         ${BLUE}${NC}"
        echo -e "${BLUE}${YELLOW} 3.${NC} ${CYAN}install needed pkgs and swap${NC}         ${BLUE}${NC}"
        echo -e "${BLUE}${YELLOW} 0.${NC} ${CYAN}exit${NC}         ${BLUE}${NC}"
        echo -e "This bash  was created by ${GREEN}ArmanATI${NC}\n"

    read -p "Enter option number: " choice
    case $choice in

          #install pkgs
        1)    
            clear
            echo -e "${GREEN}installing usb${NC}" 
            echo ""
            opkg update
            opkg install block-mount kmod-fs-ext4 e2fsprogs parted
            opkg install kmod-usb-storage-uas
            opkg install usbutils
            opkg install libblkid
            opkg install block-mount
            opkg install gdisk
            lsusb -t
            ls -l /dev/sd*
            block info | grep "/dev/sd"
            ls -l /sys/block
            DISK="/dev/sda"
            parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
            DEVICE="${DISK}1"
            mkfs.ext4 -L extroot ${DEVICE}
            eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
            eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
            uci -q delete fstab.extroot
            uci set fstab.extroot="mount"
            uci set fstab.extroot.uuid="${UUID}"
            uci set fstab.extroot.target="${MOUNT}"
            uci commit fstab
            mount ${DEVICE} /mnt
            tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -
            DEVICE="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
            uci -q delete fstab.rwm
            uci set fstab.rwm="mount"
            uci set fstab.rwm.device="${DEVICE}"
            uci set fstab.rwm.target="/rwm"
            uci commit fstab
            echo ""
            echo -e "Press ${RED}ENTER${NC} to continue"
            read -s -n 1
            ;;
        
          #install swap
        2)
            clear
            echo -e "${GREEN}installing swap${NC}" 
            echo ""
            cd
            apt update && apt upgrade -y
            grep Swap /proc/meminfo
            sudo swapoff -a
            sudo dd if=/dev/zero of=/swapfile bs=1G count=8
            sudo chmod 0600 /swapfile
            sudo mkswap /swapfile
            sudo swapon /swapfile
            grep Swap /proc/meminfo
            echo ""
            echo -e "Press ${RED}ENTER${NC} to continue"
            read -s -n 1
            ;;
            
          #install swap and pkgs
        3)    
            clear
            echo -e "${GREEN}installing swap and pkgs${NC}" 
            echo ""
            cd
            apt update && apt upgrade -y
            git clone https://github.com/akhilnarang/scripts
            cd scripts
            ./setup/android_build_env.sh
            sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-gtk3-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev -y
            clear
            echo -e "${GREEN}installing swap${NC}" 
            echo ""
            cd
            apt update && apt upgrade -y
            grep Swap /proc/meminfo
            sudo swapoff -a
            sudo dd if=/dev/zero of=/swapfile bs=1G count=8
            sudo chmod 0600 /swapfile
            sudo mkswap /swapfile
            sudo swapon /swapfile
            grep Swap /proc/meminfo
            echo ""
            echo -e "Press ${RED}ENTER${NC} to continue"
            read -s -n 1
            ;;
            
        # EXIT
        0)
            echo ""
            echo -e "${GREEN}Exiting...${NC}"
            echo "Exiting program"
            exit 0
            ;;
         *)
           echo "Invalid option. Please choose a valid option."
           echo ""
           echo -e "Press ${RED}ENTER${NC} to continue"
           read -s -n 1
           ;;
      esac
     done   
