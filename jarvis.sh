#!/bin/bash
# JARVIS-DROID Main Controller

LOG_DIR="$HOME/jarvis-droid/logs"
DATA_DIR="$HOME/jarvis-droid/data"

show_menu() {
    clear
    echo "╔════════════════════════════╗"
    echo "║     JARVIS-DROID ONLINE    ║"
    echo "╠════════════════════════════╣"
    echo "║ 1) Battery Log             ║"
    echo "║ 2) Crypto Price Tracker    ║"
    echo "║ 3) Voice Note (5 sec)      ║"
    echo "║ 4) GitHub Backup           ║"
    echo "║ 5) System Uptime           ║"
    echo "║ 6) Run All                 ║"
    echo "║ 7) View Logs               ║"
    echo "║ 8) Push to GitHub          ║"
    echo "║ 9) Exit                    ║"
    echo "╚════════════════════════════╝"
}

battery() {
    termux-battery-status | jq '.' | tee -a "$LOG_DIR/battery.log"
    termux-battery-status | jq '.percentage' >> "$DATA_DIR/battery_percent.txt"
}

crypto() {
    curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,dogecoin&vs_currencies=usd" | jq '.' | tee -a "$LOG_DIR/crypto.log"
}

voicenote() {
    termux-microphone-record -f "$DATA_DIR/note_$(date +%Y%m%d_%H%M%S).wav" -d 5
    echo "Voice note saved at $(date)" >> "$LOG_DIR/voice.log"
}

github_backup() {
    gh repo list --limit 30 > "$BACKUP_DIR/repos_$(date +%Y%m%d).txt"
    echo "GitHub repo list backed up" >> "$LOG_DIR/backup.log"
}

uptime() {
    uptime | tee -a "$LOG_DIR/uptime.log"
}

run_all() {
    battery
    crypto
    uptime
    echo "All modules executed at $(date)" >> "$LOG_DIR/auto_run.log"
}

view_logs() {
    echo "===== BATTERY ====="
    tail -5 "$LOG_DIR/battery.log" 2>/dev/null || echo "No battery log"
    echo "===== CRYPTO ====="
    tail -5 "$LOG_DIR/crypto.log" 2>/dev/null || echo "No crypto log"
    echo "===== UPTIME ====="
    tail -5 "$LOG_DIR/uptime.log" 2>/dev/null || echo "No uptime log"
}

push_to_github() {
    cd ~/jarvis-droid
    git add data/ logs/ backup/ jarvis.sh
    git commit -m "JARVIS update: $(date +%Y%m%d_%H%M%S)"
    git push
    echo "Pushed to GitHub at $(date)" >> "$LOG_DIR/git_push.log"
}

# Main
if [[ $1 == "battery" ]]; then battery
elif [[ $1 == "crypto" ]]; then crypto
elif [[ $1 == "uptime" ]]; then uptime
elif [[ $1 == "all" ]]; then run_all && push_to_github
else
    while true; do
        show_menu
        read -p "Choose option: " opt
        case $opt in
            1) battery ;;
            2) crypto ;;
            3) voicenote ;;
            4) github_backup ;;
            5) uptime ;;
            6) run_all ;;
            7) view_logs ;;
            8) push_to_github ;;
            9) echo "Goodbye!"; exit 0 ;;
            *) echo "Invalid"; sleep 1 ;;
        esac
        echo "Press Enter to continue..."; read
    done
fi
