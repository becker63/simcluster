
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "k3s" {
  name      = "k3s"
  mode      = "nat"
  domain    = "k3s.local"
  addresses = ["10.0.0.0/24"]

  dns {
    enabled = true
  }
}

resource "libvirt_volume" "nixos_boot" {
  name   = "nixos_boot"
  pool   = "default"
  source = "image.qcow2"
  format = "qcow2"
}

module "replicas" {
  source        = "./replicas"
  replica_count = 3
  volume_id     = libvirt_volume.nixos_boot.id
  network_id    = libvirt_network.k3s.id
  replica_ips   = ["10.0.0.101", "10.0.0.102", "10.0.0.103"]
}
