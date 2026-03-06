#!/bin/bash

# AcreetionOS Internet Setup Utility
# Checks for connectivity and assists with Wired/Wireless setup

check_internet() {
    ping -c 1 1.1.1.1 &>/dev/null || ping -c 1 google.com &>/dev/null
}

if check_internet; then
    exit 0
fi

# Not connected, show setup dialog
CHOICE=$(zenity --list --title="Internet Connection Required" \
    --text="AcreetionOS Lite requires an internet connection for some installation steps.\nNo active connection detected. How would you like to connect?" \
    --column="Method" --column="Description" \
    "Wired" "Attempt to connect via Ethernet (DHCP)" \
    "Wi-Fi" "Scan and connect to a Wireless network" \
    "Skip" "Continue without internet (not recommended)" \
    --width=450 --height=300)

case "$CHOICE" in
    "Wired")
        (
        echo "# Attempting to start Wired connection..."
        nmcli device connect $(nmcli device | grep ethernet | awk '{print $1}' | head -n 1) 2>/dev/null
        sleep 2
        echo "100"
        ) | zenity --progress --title="Connecting" --text="Starting Ethernet connection..." --auto-close --pulsate
        ;;
    "Wi-Fi")
        /usr/bin/wifi-connection.sh
        ;;
    "Skip")
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

if check_internet; then
    zenity --info --title="Success" --text="You are now connected to the internet!" --timeout=3
else
    zenity --error --title="Failed" --text="Still no internet connection detected. Some features may be limited."
fi
