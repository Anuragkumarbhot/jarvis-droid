# JARVIS-DROID 🤖

Termux automation suite for Android.

## Features
- Battery monitoring
- Crypto price tracking (BTC, ETH, DOGE)
- Voice notes recording
- GitHub repo backup
- Uptime logging
- Automatic push to GitHub

## Quick Start
```bash
./jarvis.sh

crontab -l

```bash
cat > .gitignore << 'EOF'
*.wav
*.tmp
*~
*.log
!logs/*.log
logs/*.log
