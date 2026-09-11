


case $(. /etc/os-release && echo $ID) in
arch)
  pacman -Syu --noconfirm
  pacman -S --noconfirm --needed sudo
  ;;
esac

awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | xargs -r -n1 userdel -r 2>/dev/null || true
useradd -m -s /bin/bash "$CONFIG_USER_NAME"
echo "$CONFIG_USER_NAME:$CONFIG_USER_NAME" | chpasswd
chown -R "$CONFIG_USER_NAME:$CONFIG_USER_NAME" "/home/$CONFIG_USER_NAME"
chmod g+s "/home/$CONFIG_USER_NAME"
echo "$CONFIG_USER_NAME ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$CONFIG_USER_NAME"

if ! getent group render >/dev/null 2>&1; then
  groupadd -g 990 -o render
  usermod -aG video "$CONFIG_USER_NAME"
  usermod -aG render "$CONFIG_USER_NAME"
fi
