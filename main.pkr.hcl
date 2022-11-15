variable "ssh_host" {
    type = string
    description = "IP or DNS name of server"
}

variable "ssh_username" {
    type = string
    description = "Name of the user which to use for login"
    default = "pi"
}

variable "ssh_auth_key" {
    type = string
    description = "Path to SSH private key which will be used to authenticate"
    default = "./pi_ed25519"
}

source "null" "server" {
    communicator = "ssh"
    ssh_host = var.ssh_host
    ssh_username = var.ssh_username
    ssh_private_key_file = var.ssh_auth_key
}

build {
    sources = [
        "null.server",
    ]

    provisioner "shell" {
        inline = [ "echo hi | wall" ]
    }
}