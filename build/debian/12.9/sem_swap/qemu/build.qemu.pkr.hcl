packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

# INFORMACAO ISO
variable "iso_url" {
  type    = string
  default = "http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
}

# INFORMACAO MAQUINA VIRTUAL
source "qemu" "debian" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum

  vm_name           = "debian-12.9.0-amd64-sem-swap"
  output_directory  = "build/debian/12.9/sem_swap/qemu/build_gerada"
  accelerator       = "kvm"
  format            = "qcow2"
  disk_size         = 10240
  memory           = "12288"
  cpus             = "4"

# INFORMACAO SSH
  ssh_username      = "packer"
  ssh_password      = "packer"
  ssh_wait_timeout  = "20m"

  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  boot_wait         = "10s"

  boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/build/debian/12.9/sem_swap/qemu/http/preseed.cfg ",
    "<enter>"
  ]

  http_directory = "."
}

build {
  sources = [
    "source.qemu.debian"
  ]

provisioner "file" {
  source      = "build/debian/12.9/sem_swap/qemu/scripts/provision.sh"
  destination = "/tmp/provision.sh"
}

provisioner "shell" {
  inline = [
    "sudo chmod +x /tmp/provision.sh",
    "sudo /tmp/provision.sh"
  ]
}
}