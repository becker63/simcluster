# Replica module: Spawns a machine with a separate volume on a shared network

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

resource "libvirt_volume" "boot" {
  count          = var.replica_count
  name           = "node_${count.index + 1}_boot"
  base_volume_id = var.volume_id
}

resource "libvirt_domain" "node" {
  count = var.replica_count

  name = "node_${count.index + 1}"

  memory = var.memory

  disk {
    volume_id = libvirt_volume.boot[count.index].id
  }

  network_interface {
    network_id     = var.network_id
    addresses  = [var.replica_ips[count.index]]
    wait_for_lease = true
  }
}
