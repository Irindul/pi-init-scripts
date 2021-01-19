#!/usr/bin/env bash
set -o errexit
set -o nounset

### VARIABLES ### 
USERNAME="mat"
COMMON_FILE="./common.sh"
INSTALL_SCRIPT="./install.sh"

source "${COMMON_FILE}"

echo_ok "Running init script for Raspberry Pi <3"

create_user() {
  local username=$1
  echo_info "Creating user ${username}"

  #--gecos disable user information such as Full Name etc..
  sudo adduser --gecos "" "${username}" 
  echo_info "Adding user ${username} to groups adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi"
  sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi "${username}" 
  echo_ok "Succesfully created user ${username}"
}

if [ -z "${USERNAME}" ]; then 
  read -p "username for the newuser: " USERNAME
fi

create_user "${USERNAME}"
chmod +x "${INSTALL_SCRIPT}"
sudo -u "${USERNAME}" "${INSTALL_SCRIPT}"

exit 0
