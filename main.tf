# Networks
resource "hcloud_network" "test_network" {
    name = "test-net"
    ip_range = "192.168.0.0/16"
}

resource "hcloud_network_subnet" "rancher_mgmt_subnet" {
    network_id = hcloud_network.test_network.id
    type = "cloud"
    network_zone = "eu-central"
    ip_range = "192.168.1.0/24"
}

# VMs
resource "hcloud_server" "rancher_mgmt_nodes" {
    count = var.server_count
    name = "rancher-mgmt-${count.index + 1}"
    image = "debian-12"
    server_type = "cx22"
    location = "nbg1"
    ssh_keys = [ "sascha@desktop.homenet.saschagaspar.net#Windows", "sgaspar@mbsgaspar", "sascha@router.homenet.saschagaspar.net" ]
}

# Add nodes to subnet
resource "hcloud_server_network" "rancher_node_subnet_registration" {
    count     = var.server_count
    server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
    subnet_id = hcloud_network_subnet.rancher_mgmt_subnet.id
}

# Volumes

resource "hcloud_volume" "rancher_volume-1" {
  count     = var.server_count
  name      = "rancher-volume-${count.index + 1}-1"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = false
  # format    = "xfs"
  depends_on = [
    hcloud_server_network.rancher_node_subnet_registration
  ]
}

resource "hcloud_volume" "rancher_volume-2" {
  count     = var.server_count
  name      = "rancher-volume-${count.index + 1}-2"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = false
  # format    = "xfs"
  depends_on = [
    hcloud_volume.rancher_volume-1
  ]
}

resource "hcloud_volume" "rancher_volume-3" {
  count     = var.server_count
  name      = "rancher-volume-${count.index + 1}-3"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = false
  # format    = "xfs"
  depends_on = [
    hcloud_volume.rancher_volume-2
  ]
}

resource "local_file" "hosts_cfg" {
    content = templatefile(
        "${path.module}/inventory.tftpl",
        {
            user = "root"
            nodes = hcloud_server.rancher_mgmt_nodes.*.ipv4_address
        }
    )
    filename = "./inventory.yaml"
}

resource "local_file" "setup_sh" {
    content = templatefile(
        "${path.module}/setup.tftpl",
        {
            nodes = hcloud_server.rancher_mgmt_nodes.*.ipv4_address
        }
    )
    filename = "./setup.sh"
}

/*
resource "terraform_data" "script" {
    depends_on = [
        local_file.hosts_cfg,
        local_file.setup_sh,
        hcloud_volume.rancher_volume-3
    ]

    provisioner "local-exec" {
        command = <<EOT
            ./setup.sh
            # ansible-playbook -u root -i inventory.yaml ../Ansible/update.yaml
            ansible -i inventory.yaml all -m ping
        EOT
    }
}
*/