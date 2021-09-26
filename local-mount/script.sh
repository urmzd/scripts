#!/bin/bash
# @Author: Urmzd Mukhammadnaim, urmzd@dal.ca
# @Date: 2021-09-19
# @Description: Mounts `timberlea` server onto local for ease of transfer and use.

# Check if VPN exists
if [[ ! -f /opt/cisco/anyconnect/bin/vpn ]] 
then
  # Install VPN
  sudo /bin/sh "./anyconnect.sh" &&

  # Create symbolic link to $PATH
  sudo rm /usr/bin/anyconnect &&
  sudo ln -s /opt/cisco/anyconnect/bin/vpn /usr/bin/anyconnect
fi &&

# Connect to VPN
anyconnect connect vpn.its.dal.ca &&

# Install SSH pass to automate password passing.
if [[ ! -f /usr/bin/sshpass ]]
then
  sudo apt-get install -q -y sshpass
fi &&

if [[ ! -f /usr/bin/sshfs ]]
then
  sudo apt-get install -q -y sshfs
fi &&

# Check if CSID and password is provided.
csid=$1 &&
password=$2 &&

if [[ -z "$csid" ]]
then
  echo "CSID is required!" && exit 1
fi &&

if [[ -z "$password" ]] 
then
  echo "Password is required!" && exit 1;
fi &&

export SSHPASS=${password} &&

ssh_host_name="timber" &&
# Declare the file name of the SSH keys.
ssh_key_filename="$HOME/.ssh/${ssh_host_name}_25519" &&

# Generate SSH key with no passphrase at home.
ssh-keygen -t "ed25519" -N "" -f "${ssh_key_filename}" &&

# Move PUBLIC key over to timberlea server.
ssh_path="${csid}@timberlea.cs.dal.ca"

sshpass -e ssh-copy-id -i "${ssh_key_filename}.pub" "$ssh_path" &&

# Execute command.
sshpass -e ssh ${ssh_path} "chmod go-w ~ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys" &&

# Create timberlea configuration to reduce host name.
ssh_config=$(cat <<-END

Host ${ssh_host_name}
  HostName timberlea.cs.dal.ca
  User ${csid}
  IdentityFile ${ssh_key_filename} 
  ServerAliveInterval 15

END
) &&

# Append timberlea configuration to ssh_config file.
echo "$ssh_config" >> ""$HOME"/.ssh/config" &&


# Define paths.
user_path="${csid}@${ssh_host_name}:/users/cs/${csid}" &&
mount_path="${HOME}/${ssh_host_name}"

# Mount timberlea onto local.
mkdir -p "${mount_path}" &&
sshfs -o idmap=user "$user_path" "${mount_path}" &&

# Create a shortcut to execute commands on server.
echo "\nalias timberlea='ssh timber'" >> "${HOME}/.${0}rc"

# Indicate completion.
echo "DONE! Enjoy using SSH for everything timberlea :)"
