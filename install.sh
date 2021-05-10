#!/usr/bin/env bash

### VARIABLES ### 
COMMON_FILE="./common.sh"
NVM_INSTALLER_VERSION="0.38.0"
### 

source "${COMMON_FILE}"

USERNAME=$(whoami)
echo_info "Running other configurations as user ${user}"

default_editor() {
    echo_info "Setting default editor as vim"
    echo "export EDITOR=vim" >> ~/.bashrc
}

enable_sudo_pwd() {
    echo "${USERNAME} ALL=(ALL) PASSWD: ALL" | sudo EDITOR='tee -a' visudo
    echo_ok "sudo now requires a password"
}

install_packages() {
    echo_info "Running updates"
    sudo apt update -y
    sudo apt upgrade -y
    
   
     #@todo Mathieu Regnard 2021-01-19 : Add docker as an optional args (./init --docker or something like that), I may not want docker every time
    sudo apt install -y vim ufw fail2ban docker-compose

    echo_ok "System update and packages installation done"
}


install_docker() {
    curl -fsSL https://get.docker.com/rootless | sh
}

install_nvm_and_node() {
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_INSTALLER_VERSION}/install.sh" | bash
    source ~/.bashrc
    local nvm_version=$(nvm --version)
    echo_ok "Nvm installed with version ${nvm_version}"
    nvm install --lts
    local node_version=$(node --version)
    echo_ok "Node installed with version ${node_version}"
}

secure_ssh_access() {
    echo_info "Securing SSH access"

    echo_prompt "Enter ssh public key to authorize ssh login: "
    SSH_PUBLIC_KEY=""
    read SSH_PUBLIC_KEY


    mkdir -p ~/.ssh 
    echo "${SSH_PUBLIC_KEY}" > ~/.ssh/authorized_keys

    sudo cp /etc/ssh/sshd_config /tmp/
    sudo chown "${USERNAME}:${USERNAME}" /tmp/sshd_config


    echo_info "Allowing ${USERNAME} to SSH in"
    echo "AllowUsers ${USERNAME}" >> /tmp/sshd_config 
    sudo chown "root:root" /tmp/sshd_config
    sudo mv /tmp/sshd_config /etc/ssh/sshd_config
    echo_info "Disabling root login"
    sudo sed -i "s/#PermitRootLogin .*/PermitRootLogin no/g" /etc/ssh/sshd_config
    echo_info "Enabling public key autentication"
    sudo sed -iE "s/#PubkeyAuthentication .*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
    echo_info "Diabling password authentication"
    sudo sed -iE "s/#PasswordAuthentication .*/PasswordAuthentication no/g" /etc/ssh/sshd_config
    echo_info "Disabling PAM"
    sudo sed -iE "s/#UsePAM .*/UsePAM no/g" /etc/ssh/sshd_config
    sudo service ssh reload
    echo_ok "SSH configuration done"
}

firewall_rules() {
    echo_info "Disabling all INCOMING traffic"
    sudo ufw default deny incoming
    echo_info "Authorizing SSH Port"
    sudo ufw allow 22 
    sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf
    echo "y" | sudo ufw enable
    echo_done "Firewall up and running"
    sudo systemctl enable ufw
}

fail2ban_config() {
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    echo "[ssh]" >> /etc/fail2ban/jail.local
    echo "enabled  = true" >> /etc/fail2ban/jail.local
    echo "port     = ssh" >> /etc/fail2ban/jail.local
    echo "filter   = sshd" >> /etc/fail2ban/jail.local
    echo "logpath  = /var/log/auth.log" >> /etc/fail2ban/jail.local
    echo "maxretry = 6" >> /etc/fail2ban/jail.local
}

# Additional commands that must be manually ran after the script is executed
print_additional_command() {
    echo_info "Some additional commands must be run in order finish the setup: "
    echo -e "\tsudo pkill -u pi"
    echo -e "\tsudo deluser --remove-home pi"
}

default_editor
enable_sudo_pwd

### APT ###
install_packages
install_docker
install_nvm_and_node

### Security ### 
secure_ssh_access
firewall_rules
fail2ban_config


source ~/.bashrc 
echo_ok "bashrc reloaded :)"
echo_ok "RASPBERRY CONFIG DONE"

print_additional_command