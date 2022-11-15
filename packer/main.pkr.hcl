source "null" "server" {
    communicator = "ssh"
    ssh_host = var.ssh_host
    ssh_username = var.ssh_username
    ssh_private_key_file = var.ssh_auth_key
}

locals {
    remote_wrk_dir = "/tmp"
}

build {
    sources = [
        "null.server",
    ]

    provisioner "file" {
        source = "${path.root}/remote-scripts/common.sh"
        destination = "${local.remote_wrk_dir}/common.sh"
    }

    provisioner "shell" {
        inline = [
            "chmod +x ${local.remote_wrk_dir}/common.sh",
        ]
    }

    provisioner "shell" {
        script = "${path.root}/remote-scripts/setup-remote.sh"
        remote_folder = local.remote_wrk_dir
    }
}