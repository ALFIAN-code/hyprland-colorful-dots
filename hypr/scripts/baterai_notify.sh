#!/bin/bash
LOW_BATTERY_THRESHOLD_1=25
LOW_BATTERY_THRESHOLD_2=17
SUSPEND_THRESHOLD=10
BATTERY_DIR="/sys/class/power_supply/BAT1"

full_notify=1
is_charging=0

if [ $(cat "$BATTERY_DIR/status") = "Charging" ]; then
    is_charging=1
fi

pause=0


while true; do
    # BATTERY_LEVEL=$(cat "$BATTERY_DIR/capacity")
    BATTERY_LEVEL=20
    
    if [ $CHARGING_STATUS = "Discharging" ]; then
        if [ $BATTERY_LEVEL -le $SUSPEND_THRESHOLD ]; then
            systemctl suspend
            notify-send "Baterai Sangat Lemah" "Baterai Anda dtersisa $BATTERY_LEVEL%. Harap segera isi daya."
            pause=15
            elif [ $BATTERY_LEVEL -le $LOW_BATTERY_THRESHOLD_1 ]; then
            notify-send "Baterai Lemah" "Baterai Anda dtersisa $BATTERY_LEVEL%. Harap segera isi daya."
            pause=30
        fi
        
    else
        if [[ $BATTERY_LEVEL -eq 100 && $full_notify -eq 1 ]]; then
            full_notify=0
            notify-send "Baterai Penuh" "Baterai Anda telah penuh."
            elif [ $BATTERY_LEVEL -lt 80 ]; then
            full_notify=1
        fi
    fi
sleep $pause

done