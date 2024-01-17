# 🚀 SSH Utilities

Welcome to the SSH Utilities repository! This collection of scripts makes managing and interacting with remote servers a breeze. Whether you need to set up SSH access or mount a remote directory to your local machine, we've got you covered!

## 📜 Scripts

This repository contains two main scripts:

1. **mount-remote-path-to-local.sh**: Mounts a remote server's file system onto your local machine using SSHFS.
2. **set-up-ssh-server.sh**: Sets up SSH key-based authentication for a user on a specified host.

## 📖 How to Use

### 1. Mounting Remote Path to Local Machine

#### Script: `mount-remote-path-to-local.sh`

- **Purpose**: Easily mount a directory from a remote server to your local machine for file transfer and access.
- **Usage**:
  ```bash
  ./mount-remote-path-to-local.sh <USER_NAME> <SSH_HOST_NAME> <REMOTE_PATH>
  ```
- **Requirements**: `sshfs` and `sshpass` must be installed on your local machine.

### 2. Setting Up SSH Server

#### Script: `set-up-ssh-server.sh`

- **Purpose**: Automate the creation of SSH keys and establish key-based authentication for accessing a remote server.
- **Usage**:
  ```bash
  ./set-up-ssh-server.sh <USER_NAME> <PASSWORD> <SSH_KEY_NAME> <SSH_HOST_NAME>
  ```
- **Requirements**: Your local machine should have `ssh-keygen`, `sshpass`, and `ssh-copy-id` available.

## 🛠 Installation

Clone this repository to your local machine using:

```bash
git clone https://github.com/urmzd/ssh-utils.git
cd src
```

Make sure to give the scripts execution permissions:

```bash
chmod +x mount-remote-path-to-local.sh set-up-ssh-server.sh
```

## 🔐 Security

- Handle your credentials securely.
- It's recommended to understand the security implications involved in scripts that automate SSH authentication and mount remote filesystems.

## 📬 Feedback

If you have any feedback or suggestions, feel free to open an issue in the repository!

---

💖 Thank you for visiting our repository!

