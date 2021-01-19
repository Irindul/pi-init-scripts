# Init scripts for Raspberry Pi

This scripts are used to create a basic secure environment when reinstalling RaspberryPi OS. 

## Usage 

`$ chmod +x init.sh`
`$ ./init.sh`

## Contents

This scripts does several tasks : 
* Create a new user called `mat` 
* Set vim as the default editor
* Forces a password for sudo for the new user
* Updates packages and installs some basic stuff (vim, docker, fail2ban, ufw etc...)
* Secure SSH access (disabling root login, disabling password login etc..)
* Configure ufw to allow SSH only
* Configure fail2ban

All the steps are followed from official raspberry pi documentation : https://www.raspberrypi.org/documentation/configuration/security.md