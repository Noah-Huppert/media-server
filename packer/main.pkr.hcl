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