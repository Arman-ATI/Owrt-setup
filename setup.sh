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
        echo -e "${BLUE}${YELLOW} 2.${NC} ${CYAN}install v2ray${NC}         ${BLUE}${NC}"
        echo -e "${BLUE}${YELLOW} 3.${NC} ${CYAN}install usb and v2ray${NC}         ${BLUE}${NC}"
        echo -e "${BLUE}${YELLOW} 0.${NC} ${CYAN}exit${NC}         ${BLUE}${NC}"
        echo -e "This bash  was created by ${GREEN}ArmanATI${NC}\n"

    read -p "Enter option number: " choice
    case $choice in

          #install usb
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
        
          #install v2ray
        2)
            clear
            echo -e "${GREEN}installing v2ray${NC}" 
            echo ""
            wget https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03
            echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo "$DISTRIB_ARCH")" | tee -a "/etc/opkg/customfeeds.conf"
            opkg update
            opkg install v2raya
            opkg install kmod-nft-tproxy
            opkg install iptables-mod-conntrack-extra
            opkg install iptables-mod-extra
            opkg install iptables-mod-filter
            opkg install iptables-mod-tproxy
            opkg install kmod-ipt-nat6
            opkg install xray-core
            opkg install v2fly-geoip v2fly-geosite
            opkg install luci-app-v2raya
            echo ""
            echo -e "Press ${RED}ENTER${NC} to continue"
            read -s -n 1
            ;;
            
          #install usb and v2ray
        3)    
            clear
            echo -e "${GREEN}installing USB and v2ray${NC}" 
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
            clear
            echo -e "${GREEN}installing v2ray${NC}" 
            echo ""
            wget https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03
            echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo "$DISTRIB_ARCH")" | tee -a "/etc/opkg/customfeeds.conf"
            opkg update
            opkg install v2raya
            opkg install kmod-nft-tproxy
            opkg install iptables-mod-conntrack-extra
            opkg install iptables-mod-extra
            opkg install iptables-mod-filter
            opkg install iptables-mod-tproxy
            opkg install kmod-ipt-nat6
            opkg install xray-core
            opkg install v2fly-geoip v2fly-geosite
            opkg install luci-app-v2raya
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
