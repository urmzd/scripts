#!/usr/bin/env bash
# Author: Urmzd Mukhammadnaim
# Date: 2023-09-19


# Check if USER_NAME and PASSWORD is provided.
USER_NAME="$1"
PASSWORD="$2"
SSH_KEY_NAME="$3"
SSH_HOST_NAME="$4"

# VALIDATE ABOVE

# Check if USER_NAME is provided.
if [[ -z "$USER_NAME" ]]
then
  echo "Please provide your USER_NAME as the first argument."
  exit 1
fi

# Check if PASSWORD is provided.
if [[ -z "$PASSWORD" ]]
then
  echo "Please provide your PASSWORD as the second argument."
  exit 1
fi

# Check if SSH_KEY_NAME is provided.
if [[ -z "$SSH_KEY_NAME" ]]
then
  echo "Please provide your SSH_KEY_NAME as the third argument."
  exit 1
fi

# Check if SSH_HOST_NAME is provided.
if [[ -z "$SSH_HOST_NAME" ]]
then
  echo "Please provide your SSH_HOST_NAME as the fourth argument."
  exit 1
fi

export SSHPASS="${PASSWORD}"

# DEFINE PATHS
SSH_PATH="${USER_NAME}@${SSH_HOST_NAME}"

# Declare the file name of the SSH keys.
SSH_KEY_FILE_NAME="$HOME/.ssh/${SSH_KEY_NAME}"

# Generate SSH key with no passphrase at home.
ssh-keygen -t "ed25519" -N "" -f "${SSH_KEY_FILE_NAME}"

# Copy SSH key over to server.
sshpass -e ssh-copy-id -i "${SSH_KEY_FILE_NAME}.pub" "$SSH_PATH"

# Execute command.
sshpass -e ssh ${SSH_PATH} "chmod go-w ~ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

# Create timberlea configuration to reduce host name.
SSH_CONFIG=$(cat <<-END

Host ${SSH_KEY_NAME}
  HostName ${SSH_HOST_NAME}
  User ${USER_NAME}
  IdentityFile ${SSH_KEY_FILE_NAME} 
  ServerAliveInterval 15

END
) 

# Append configuration to ssh_config file.
echo "$SSH_CONFIG" >> ""$HOME"/.ssh/config" 