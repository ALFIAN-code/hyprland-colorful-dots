#!/bin/bash
# Pastikan upower sudah terinstal dan BAT-nya terdeteksi
# Dapatkan path baterai (misalnya /org/freedesktop/UPower/devices/battery_BAT1)
BATTERY_PATH=$(upower -e | grep BAT)
LOW_BATTERY_THRESHOLD=15
SUSPEND_THRESHOLD=5

prev_state=""

# Mulai monitoring detail baterai secara real time
upower --monitor-detail "$BATTERY_PATH" | while read -r line; do
    # Jika ada perubahan state (charging/discharging)
    if echo "$line" | grep -q "state:"; then
        state=$(echo "$line" | awk '{print $2}')
        if [ "$state" != "$prev_state" ]; then
            if [ "$state" = "charging" ]; then
                notify-send "Charger Connected" "Charger telah dicolok."
            elif [ "$state" = "discharging" ]; then
                notify-send "Charger Disconnected" "Charger telah dicabut."
            fi
            prev_state="$state"
        fi
    fi

    # Jika ada perubahan level baterai
    if echo "$line" | grep -q "percentage:"; then
        # Contoh output: "  percentage:          86%"
        percentage=$(echo "$line" | awk '{print $2}' | sed 's/%//')
        
        if [ "$prev_state" = "charging" ]; then
            if [ "$percentage" -eq 100 ]; then
                notify-send "Baterai Penuh" "Baterai Anda telah penuh."
                # Setelah notifikasi penuh, tidak melakukan aksi lebih lanjut
                # Tunggu hingga ada event baterai berikutnya
            fi
        elif [ "$prev_state" = "discharging" ]; then
            if [ "$percentage" -le "$SUSPEND_THRESHOLD" ]; then
                notify-send "Baterai Sangat Lemah" "Baterai Anda tersisa $percentage%. Harap segera isi daya." -u critical
                notify-send "Sistem akan ditangguhkan" "Sistem akan ditangguhkan dalam 20 detik."
                sleep 20
                systemctl suspend
            elif [ "$percentage" -le "$LOW_BATTERY_THRESHOLD" ]; then
                notify-send "Baterai Lemah" "Baterai Anda tersisa $percentage%. Harap segera isi daya." -u critical
            fi
        fi
    fi
done
