
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
  addresses = ["10.240.0.0/24"]

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}

resource "libvirt_volume" "nixos_boot" {
  name   = "nixos_boot.qcow2"
  pool   = "default"
  source = "machines/snode/image/nixos.qcow2"
  format = "qcow2"
}

module "replicas" {
  source        = "./machines/snode/replicas"
  replica_count = 3
  volume_id     = libvirt_volume.nixos_boot.id
  network_id    = libvirt_network.k3s.id
}
