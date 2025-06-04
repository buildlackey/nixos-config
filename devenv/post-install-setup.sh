dconf load / < /etc/nixos/devenv/mate-dconf-backup.ini


echo "🔧 Checking Dropbox bootstrap..."

if [ ! -d "$HOME/.dropbox-dist" ]; then
  echo "📦 First-time Dropbox initialization..."
  dropbox start -i
  echo "✅ Dropbox GUI should prompt for login. Once done, press Enter to continue..."
  read -r
else
  echo "✅ Dropbox already initialized."
fi

echo "📡 Starting Dropbox service..."
systemctl --user enable dropbox.service
systemctl --user start dropbox.service

echo "✅ Dropbox should now be running and syncing."



