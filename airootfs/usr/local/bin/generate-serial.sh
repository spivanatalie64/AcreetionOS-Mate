#!/bin/bash

# AcreetionOS Lite Machine Serial Generator
# This script generates a unique machine-specific serial number if one does not exist.

SERIAL_FILE="/etc/acreetion-serial"

if [ ! -f "$SERIAL_FILE" ]; then
    # Generate a random 12-character alphanumeric serial number
    NEW_SERIAL=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 12 | head -n 1)
    echo "ACRE-$NEW_SERIAL" > "$SERIAL_FILE"
    chmod 644 "$SERIAL_FILE"
    echo "Generated new machine serial: ACRE-$NEW_SERIAL"
else
    echo "Machine serial already exists: $(cat $SERIAL_FILE)"
fi
