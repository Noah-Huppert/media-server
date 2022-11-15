# Raspberry Pi Media Server
Configuration as code for Raspberry Pi media server.

# Table Of Contents
- [Overview](#overview)
- [Instructions](#instructions)

# Overview
Configuration as code to setup a Jellyfin media server run on a Raspberry Pi.

# Instructions
Commands in the instructions require a Unix shell environment. If you do not have access to a Unix shell the [`dev-container/`](./dev-container/) directory contains instructions on how to use a Docker Compose stack with a Unix shell and all the required dependencies. 

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
   
   If you do not have a SSH key generate one using the command:
   ```bash
   ssh-keygen -t ed25519 -f keys/pi_ed25519 -C "pi"
   ```
   (Do not commit these files to Git)

## Configuration As Code Powered Setup
The following steps indicate how to apply the steps in the configuration as code:

1. Run Packer:
   ```bash
   packer build -var "ssh_host=<pi host>" -var "ssh_auth_key=<ssh private key path>" ./packer
   ```
   Be sure to replace the following:
     - `<pi host>`: IP address or host of the PI server
     - `<ssh private key path>`: Path to the SSH private key used to authenticate with the PI
   The `-var "ssh_username=<username>"` option can also be passed to customize the Raspberry PI's login username.

Packer has 2 build steps defined: `base-system` and `salt-apply`. The `base-system` build step bootstraps any dependencies needed to use the Salt configuration as code tool. The `salt-apply` step then uses Salt to configure the finer details of the system. To only re-run Salt execute `packer` with the `-only` option:

```bash
packer build -var "ssh_host=<pi host>" -var "ssh_auth_key=<ssh private key path>" -only=salt-apply.null.server ./packer
```