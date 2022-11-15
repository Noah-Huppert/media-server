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
    name = "base-system"

    sources = [
        "null.server",
    ]

    # Copy scripts
    provisioner "file" {
        source = "${path.root}/remote-scripts/common.sh"
        destination = "${local.remote_wrk_dir}/common.sh"
    }

    provisioner "shell" {
        inline = [
            "chmod +x ${local.remote_wrk_dir}/common.sh",
        ]
    }

    # Run setup script
    provisioner "shell" {
        script = "${path.root}/remote-scripts/setup-remote.sh"
        remote_folder = local.remote_wrk_dir
    }
}

build {
    name = "salt-apply"
    
    sources = [
        "null.server",
    ]

    # Copy Salt files
    provisioner "file" {
        source = "${path.root}/salt-conf/salt"
        destination = "${local.remote_wrk_dir}/salt"
    }

    provisioner "file" {
        source = "${path.root}/salt-conf/pillar"
        destination = "${local.remote_wrk_dir}/pillar"
    }

    provisioner "shell" {
        inline = [
            "sudo rm -rf /srv/salt || true",
            "sudo rm -rf /srv/pillar || true",
            "sudo mv ${local.remote_wrk_dir}/salt /srv/",
            "sudo mv ${local.remote_wrk_dir}/pillar /srv/",
        ]
    }

    # Run setup script
    provisioner "shell" {
        script = "${path.root}/remote-scripts/salt-apply.sh"
        remote_folder = local.remote_wrk_dir
    }
}