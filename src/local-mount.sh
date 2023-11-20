#!/bin/bash
# @Author: Urmzd Mukhammadnaim, urmzd@dal.ca
# @Date: 2021-09-19
# @Description: Mounts server onto local for ease of transfer and use.

# Check if VPN exists
if [[ ! -f /opt/cisco/anyconnect/bin/vpn ]] 
then
  # Install VPN
  sudo /bin/sh "./anyconnect.sh" 

  # Create symbolic link to $PATH
  sudo rm /usr/bin/anyconnect 
  sudo ln -s /opt/cisco/anyconnect/bin/vpn /usr/bin/anyconnect
fi

# Connect to VPN
anyconnect connect vpn.its.dal.ca || (echo "Failed to connect to VPN." && exit 1) 

if [[ ! -f /usr/bin/sshfs ]]
then
  sudo apt-get install -q -y sshfs
fi 

# Install SSH pass to automate PASSWORD passing.
if [[ ! -f /usr/bin/sshpass ]]
then
  sudo apt-get install -q -y sshpass
fi


# Define paths.
USER_PATH="${USER_NAME}@${SSH_HOST_NAME}:/users/cs/${csid}" 
MOUNT_PATH="${HOME}/${SSH_HOST_NAME}"

# Mount timberlea onto local.
mkdir -p "${MOUNT_PATH}" 
sshfs -o idmap=user "$USER_PATH" "${MOUNT_PATH}" 

# Create a shortcut to execute commands on server.
echo "" >> "${HOME}/.profile"
echo "alias timberlea='ssh timber'" >> "${HOME}/.profile"

# Remount when disconnected.
echo "" >> "${HOME}/.profile"
echo "sshfs -o reconnect,nonempty "$USER_PATH" $MOUNT_PATH" >> "${HOME}/.profile" 

# Indicate completion.
echo "DONE! Enjoy using SSH for everything timberlea :)"
