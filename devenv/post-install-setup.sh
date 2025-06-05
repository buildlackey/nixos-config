#!/usr/bin/env bash



if [ ! -d "/etc/nixos/devenv" ]; then
  echo "/etc/nixos/devenv missing.  Suggestion: run the cmds below"
  echo "rm -rf /etc/nixos ; sudo ln -s ~/nixos-config /etc/nixos"
  exit 1
fi

# ✅ Restore MATE and terminal config from dconf backup
dconf load / < /etc/nixos/devenv/mate-dconf-backup.ini

echo "🔧 Checking Dropbox bootstrap..."

if [ ! -d "$HOME/.dropbox-dist" ]; then
  echo "📦 First-time Dropbox initialization... Takes about 5 minutes, then you will see OS prompt"
  dropbox start -i
  echo "✅ Dropbox GUI should prompt for login. Once done, press Enter to continue..."
  read -r
else
  echo "✅ Dropbox already initialized."
  exit 1
fi

echo "⚙️ Ensuring Dropbox autostarts on login..."

AUTOSTART_DIR="$HOME/.config/autostart"
AUTOSTART_FILE="$AUTOSTART_DIR/dropbox.desktop"

mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Exec=dropbox start
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Dropbox
Comment=Start Dropbox on login
EOF

chmod +x "$AUTOSTART_FILE"

echo "✅ Dropbox autostart configured via desktop entry."

