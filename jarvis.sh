#!/bin/bash
LOG_DIR="$HOME/jarvis-droid/logs"
DATA_DIR="$HOME/jarvis-droid/data"

battery() { termux-battery-status | jq '.' | tee -a "$LOG_DIR/battery.log"; }
crypto() { curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,dogecoin&vs_currencies=usd" | jq '.' | tee -a "$LOG_DIR/crypto.log"; }
voicenote() { termux-microphone-record -f "$DATA_DIR/note_$(date +%Y%m%d_%H%M%S).wav" -d 5; echo "Voice note saved" >> "$LOG_DIR/voice.log"; }
github_backup() { gh repo list --limit 30 > ~/jarvis-droid/backup/repos_$(date +%Y%m%d).txt; echo "Backup done" >> "$LOG_DIR/backup.log"; }
uptime() { uptime | tee -a "$LOG_DIR/uptime.log"; }
run_all() { battery; crypto; uptime; echo "All done at $(date)" >> "$LOG_DIR/auto_run.log"; }
view_logs() { tail -10 "$LOG_DIR/battery.log" 2>/dev/null; tail -10 "$LOG_DIR/crypto.log" 2>/dev/null; }
push() { cd ~/jarvis-droid && git add logs/ data/ backup/ && git commit -m "Auto push $(date +%Y%m%d_%H%M%S)" && git push; }

PS3="Choose option (1-9): "
options=("Battery Log" "Crypto Price Tracker" "Voice Note" "GitHub Backup" "System Uptime" "Run All" "View Logs" "Push to GitHub" "Exit")
select opt in "${options[@]}"; do
    case $opt in
        "Battery Log") battery ;;
        "Crypto Price Tracker") crypto ;;
        "Voice Note") voicenote ;;
        "GitHub Backup") github_backup ;;
        "System Uptime") uptime ;;
        "Run All") run_all ;;
        "View Logs") view_logs ;;
        "Push to GitHub") push ;;
        "Exit") exit 0 ;;
        *) echo "Invalid";;
    esac
    echo "Press Enter to continue..."
    read
done
