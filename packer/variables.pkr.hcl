# Connection
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
    default = "./keys/pi_ed25519"
}