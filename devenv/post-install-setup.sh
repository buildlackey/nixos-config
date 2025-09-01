#!/usr/bin/env bash

# 📁 Validate that devenv is correctly linked
if [ ! -d "/etc/nixos/devenv" ]; then
  echo "/etc/nixos/devenv missing.  Suggestion: run the cmds below"
  echo "rm -rf /etc/nixos ; sudo ln -s ~/nixos-config /etc/nixos"
  exit 1
fi


# Install flatpak for intellij Idea ultimate - replaces community edition we 
# Installed via nixos package manager..   The flakpak install method avoids .so library
# sharing which nixos makes tricky due to non-standard paths.  But it duplicates .so libs that
# otherwise would be shared...  That's the price we have to pay to run idea though.
#
echo ">>> Ensuring Flathub remote is added..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo ">>> Installing IntelliJ IDEA Ultimate (Flatpak)..."
flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Ultimate
echo ">>> Flatpak list check:"
flatpak list | grep IntelliJ || echo "⚠️ WARNING IntelliJ not found"


#  supress annoying nautilus file mgr warnings
touch ~/.gtk-bookmarks
mkdir -p ~/.cache/thumbnails/normal



# ✅ Restore MATE panel, terminal, etc config from dconf backup
dconf load / < /etc/nixos/devenv/mate-dconf-backup.ini
dconf load /org/mate/panel/ < /etc/nixos/devenv/mate-panel-dconf-backup.ini


# ✅ Restore sound settings
amixer set Master unmute
amixer set Master 80%


echo "🔧 Checking Dropbox bootstrap..."

if [ ! -d "$HOME/.dropbox-dist" ]; then
  echo "📦 First-time Dropbox initialization... Takes about 5 minutes, then you will see OS prompt"
  dropbox start -i
  echo "✅ Dropbox GUI should prompt for login. Once done, press Enter to continue..."
  read -r
else
  echo "✅ Dropbox already initialized."
fi

echo "⚙️ Ensuring Dropbox autostarts on login..."

AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_DIR/dropbox.desktop" <<EOF
[Desktop Entry]
Type=Application
Exec=dropbox start
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Dropbox
Comment=Start Dropbox on login
EOF

chmod +x "$AUTOSTART_DIR/dropbox.desktop"

echo "✅ Dropbox autostart configured via desktop entry."

# 📦 First-time Insync setup
echo "🔧 Checking Insync bootstrap..."

if [ ! -d "$HOME/.config/Insync" ]; then
  echo "📦 First-time Insync initialization..."
  (cd $HOME ; insync start &)		# running from /etc/nixos causes issues
  echo "✅ Insync GUI should prompt for login. Once done, press Enter to continue..."
  read -r
else
  echo "✅ Insync already initialized."
fi

echo "⚙️ Ensuring Insync autostarts on login..."

cat > "$AUTOSTART_DIR/insync.desktop" <<EOF
[Desktop Entry]
Type=Application
Exec=insync start
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Insync
Comment=Start Insync on login
EOF

chmod +x "$AUTOSTART_DIR/insync.desktop"

echo "✅ Insync autostart configured via desktop entry."


cd $HOME

## Git config
cp /etc/nixos/devenv/git.config ~/.gitconfig   
cp /etc/nixos/devenv/git.ignore ~/.gitignore

ln -s  ~/Dropbox/projects/devEnv/config/.gitignore  ~/.gitignore


## ssh config
rm -rf ~/.ssh
ln -s ~/Dropbox/projects/devEnv/config/ssh ~/.ssh
chmod 500  ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa*
chmod 700 ~/.ssh


rm -f $HOME/config
ln -s Dropbox/projects/devEnv/config/

rm -f $HOME/scripts
ln -s Dropbox/projects/devEnv/scripts

rm -f $HOME/.vimrc
ln -s /etc/nixos/devenv/vim.rc  .vimrc


rm -f $HOME/.ideavimrc
ln -s Dropbox/projects/devEnv/config/.ideavimrc .ideavimrc

rm -rf $HOME/.vim
ln -s Dropbox/projects/devEnv/config/vim .vim


grep "config.bashrc"  ~/.bashrc
if [ "$?"  -eq  "0" ] ; then
	echo skipping bashrc config
else
	echo adding bashrc config
	echo ". \$HOME/config/bashrc" >> ~/.bashrc
fi


## Password setup
/etc/nixos/devenv/change_passwd.sh


