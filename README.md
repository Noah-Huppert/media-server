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

1. Create a file named `packer/host.pkrvars.hcl` with the contents:
   ```hcl
   ssh_host = "<pi host>"
   ```
   This file will be provided to Packer and will set variable values in [`./packer/variables.pkr.hcl`](./packer/variables.pkr.hcl). Check the default values of these variables, if any do not match your environment place new values in the `host.pkrvars.hcl` file.
2. Run Packer:
   ```bash
   ./scripts/packer-build.sh
   ```
   This may fail the first time, as certain Kernel options are set which require a reboot to work. SSH into the server, reboot, and re-run the above command.

Packer has 2 build steps defined: `base-system` and `salt-apply`. The `base-system` build step bootstraps any dependencies needed to use the Salt configuration as code tool. The `salt-apply` step then uses Salt to configure the finer details of the system. To only re-run Salt execute `./scripts/packer-build.sh` with the `salt-apply` argument.

```bash
./scripts/packer-build.sh salt-apply
```