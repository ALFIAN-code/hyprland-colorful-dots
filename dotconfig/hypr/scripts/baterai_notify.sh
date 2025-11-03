#!/bin/bash

BATTERY_PATH=$(upower -e | grep -m1 BAT)
LOW_LEVELS=(20 15 7)
SUSPEND_THRESHOLD=7
COUNTDOWN=30
notified_levels=()
countdown_pid=""
last_state=""

notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    notify-send -u "$urgency" "$title" "$message"
}

cancel_countdown() {
    if [ -n "$countdown_pid" ] && kill -0 "$countdown_pid" 2>/dev/null; then
        kill "$countdown_pid"
        notify "Suspend Dibatalkan" "Charger terdeteksi, sistem tidak jadi ditangguhkan."
        countdown_pid=""
    fi
}

start_countdown() {
    cancel_countdown
    (
        for ((i=COUNTDOWN; i>0; i-=2)); do
            sleep 2
            current_state=$(upower -i "$BATTERY_PATH" | awk '/state:/ {print $2}')
            if [ "$current_state" = "charging" ]; then
                exit 0
            fi
        done
        current_state=$(upower -i "$BATTERY_PATH" | awk '/state:/ {print $2}')
        if [ "$current_state" = "discharging" ]; then
            notify "Menangguhkan Sistem" "Baterai sangat rendah. Sistem akan segera ditangguhkan." critical
            systemctl suspend
        fi
    ) &
    countdown_pid=$!
}

check_battery() {
    info=$(upower -i "$BATTERY_PATH")
    state=$(echo "$info" | awk '/state:/ {print $2}')
    percentage=$(echo "$info" | awk '/percentage:/ {gsub("%",""); print $2}')

    # Abaikan kalau state tidak berubah (biar nggak spam)
    if [ "$state" = "$last_state" ]; then
        return
    fi
    last_state="$state"

    if [ "$state" = "charging" ]; then
        cancel_countdown
        notified_levels=()
        notify "Charger Connected" "Baterai sedang diisi daya."
        return
    fi

    if [ "$state" = "discharging" ]; then
        notify "Charger Disconnected" "Baterai sedang digunakan."
        for level in "${LOW_LEVELS[@]}"; do
            if [ "$percentage" -le "$level" ] && [[ ! " ${notified_levels[*]} " =~ " $level " ]]; then
                if [ "$level" -eq "$SUSPEND_THRESHOLD" ]; then
                    notify "Baterai Sangat Lemah" \
                        "Baterai tinggal ${percentage}%. Sistem akan ditangguhkan dalam $COUNTDOWN detik jika charger tidak dicolok." \
                        critical
                    start_countdown
                else
                    notify "Baterai Lemah" "Baterai Anda tinggal ${percentage}%." critical
                fi
                notified_levels+=("$level")
            fi
        done
    fi
}

# Jalankan sekali di awal
check_battery

# Monitor event baterai
upower --monitor | while read -r _; do
    check_battery
done
