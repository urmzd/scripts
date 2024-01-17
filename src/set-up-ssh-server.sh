#!/usr/bin/env bash
# Author: Urmzd Mukhammadnaim
# Date: 2023-09-19
# Description: This script automates the creation of SSH keys and sets up SSH key-based 
#              authentication for a specified user on a remote host.
# Usage: ./set-up-ssh-server USER_NAME PASSWORD SSH_KEY_NAME SSH_HOST_NAME

# Checking and capturing command line arguments
USER_NAME="$1"
PASSWORD="$2"
SSH_KEY_NAME="$3"
SSH_HOST_NAME="$4"

# Validating the presence of required arguments
if [[ -z "$USER_NAME" ]]; then
  echo "Please provide your USER_NAME as the first argument."
  exit 1
fi

if [[ -z "$PASSWORD" ]]; then
  echo "Please provide your PASSWORD as the second argument."
  exit 1
fi

if [[ -z "$SSH_KEY_NAME" ]]; then
  echo "Please provide your SSH_KEY_NAME as the third argument."
  exit 1
fi

if [[ -z "$SSH_HOST_NAME" ]]; then
  echo "Please provide your SSH_HOST_NAME as the fourth argument."
  exit 1
fi

# Setting up the password for use with sshpass
export SSHPASS="${PASSWORD}"

# Constructing the SSH path
SSH_PATH="${USER_NAME}@${SSH_HOST_NAME}"

# Declaring the file path for the SSH keys
SSH_KEY_FILE_NAME="$HOME/.ssh/${SSH_KEY_NAME}"

# Generating the SSH key pair
ssh-keygen -t "ed25519" -N "" -f "${SSH_KEY_FILE_NAME}"

# Copying the SSH public key to the server's authorized keys
sshpass -e ssh-copy-id -i "${SSH_KEY_FILE_NAME}.pub" "$SSH_PATH"

# Securing the SSH setup on the server
sshpass -e ssh "${SSH_PATH}" "chmod go-w ~ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

# Creating an SSH client configuration snippet
SSH_CONFIG=$(cat <<-END

Host ${SSH_KEY_NAME}
  HostName ${SSH_HOST_NAME}
  User ${USER_NAME}
  IdentityFile ${SSH_KEY_FILE_NAME}
  ServerAliveInterval 15

END
) 

# Appending the configuration to the user's SSH config file
echo "$SSH_CONFIG" >> "${HOME}/.ssh/config"
