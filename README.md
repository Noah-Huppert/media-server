# Raspberry Pi Media Server
Configuration as code for Raspberry Pi media server.

# Table Of Contents
- [Overview](#overview)
- [Instructions](#instructions)

# Overview
Configuration as code to setup a Jellyfin media server run on a Raspberry Pi.

# Instructions
Some instructions require a Unix shell environment. If you do not have access to a Unix shell the [`dev-container/`](./dev-container/) directory contains instructions on how to use a Docker Compose stack with a Unix shell and all the required dependencies. 

## Bootstrapping
Although this repository contains configuration as code, there are still some steps that must be performed manually:

1. Install [Raspberry Pi OS](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) on the Raspberry Pi using [RPI Imager](https://www.raspberrypi.com/software/)
  - Click the gear icon and configure the following:
    - Enable the SSH login option
    - If the PI will not be wired then enter WiFi network information
2. Copy your SSH public key to the `/home/pi/.ssh/authorized_keys` file:
   ```bash
   ssh-copy-id <path to key file> pi@<pi host>
   ```
   Be sure to replace:
     - `<path to key file>`: Location of your SSH private key
     - `<pi host>`: IP address of your Raspberry PI
   If your SSH public key has a comment like `user@host` then the `ssh-copy-id` will try to use the user in the key comment. Replace this comment with something not in the username at host format.

   If you do not have an SSH key generate one using the command:
   ```bash
   ssh-keygen -t ed25519 -f pi_ed25519 -C "pi"
   ```
   (Do not commit these files to Git).

## Configuration As Code Powered Setup
The following steps indicate how Packer can be used to setup the server using steps recorded via configuration as code:

1. Run Packer:
   ```bash
   packer build -var "ssh_host=<pi host>" -var "ssh_auth_key=<ssh private key path>"
   ```
   Be sure to replace the following:
     - `<pi host>`: IP address or host of the PI server
     - `<ssh private key path>`: Path to the SSH private key used to authenticate with the PI
   The `-var "ssh_username=<username>"` option can also be passed to customize the Raspberry PI's login username.