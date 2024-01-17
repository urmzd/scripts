#!/bin/bash
# Author: Urmzd Mukhammadnaim, urmzd@dal.ca
# Date: 2021-09-19
# Description: This script mounts a remote server's file system onto the local machine 
#              using SSH Filesystem (SSHFS) for easy file transfer and access.
# Usage: ./mount-remote-path-to-local.sh USER_NAME SSH_HOST_NAME REMOTE_PATH

# Check if sshfs is installed, if not, install it
if [[ ! -f /usr/bin/sshfs ]]; then
  echo "Installing SSHFS..."
  sudo apt-get install -q -y sshfs
fi 

# Capturing command line arguments for user, host, and remote path
USER_NAME="$1"
SSH_HOST_NAME="$2"
REMOTE_PATH="$3"

# Validate the presence of required arguments
if [[ -z "$USER_NAME" || -z "$SSH_HOST_NAME" || -z "$REMOTE_PATH" ]]; then
  echo "Please provide USER_NAME, SSH_HOST_NAME, and REMOTE_PATH as arguments."
  exit 1
fi

# Define the remote path on the server and the local mount path
USER_PATH="${USER_NAME}@${SSH_HOST_NAME}:${REMOTE_PATH}" 
MOUNT_PATH="${HOME}/${SSH_HOST_NAME}"

# Create a directory for mounting and mount the remote filesystem
echo "Mounting ${SSH_HOST_NAME}..."
mkdir -p "${MOUNT_PATH}" 
sshfs -o idmap=user "$USER_PATH" "${MOUNT_PATH}" 

# Create an alias for easy SSH access to the remote server
echo "Creating alias for easy access..."
echo "alias server_alias='ssh ${USER_NAME}@${SSH_HOST_NAME}'" >> "${HOME}/.bashrc"

# Add a command to remount the filesystem in case of disconnection
echo "Adding auto-reconnect feature..."
echo "sshfs -o reconnect,nonempty \"$USER_PATH\" \"$MOUNT_PATH\"" >> "${HOME}/.bashrc"

# Indicate script completion
echo "DONE! You can now access ${SSH_HOST_NAME} easily."

# Note: Remember to source .bashrc or restart the terminal to use the new alias.
