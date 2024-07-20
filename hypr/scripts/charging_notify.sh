LOW_BATTERY_THRESHOLD_1=25
LOW_BATTERY_THRESHOLD_2=17
LOW_BATTERY_THRESHOLD_1=25
SUSPEND_THRESHOLD=10
BATTERY_DIR="/sys/class/power_supply/BAT1"

full_notify=1
is_charging=0

if [ $(cat "$BATTERY_DIR/status") = "Charging" ]; then
    is_charging=1
fi

pause=0


while true; do
    CHARGING_STATUS=$(cat "$BATTERY_DIR/status")
    
    if [[ $CHARGING_STATUS = "Charging" && $is_charging -eq 0 ]]; then
        notify-send "Charger Plug in" "Charger telah terhubung."
        is_charging=1
    elif [[ $CHARGING_STATUS = "Discharging" && $is_charging -eq 1 ]]; then
        notify-send "Charger Plug out" "Charger telah dicabut."
        is_charging=0
    fi
done