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
    count = 3
    name = "rancher-mgmt-${count.index + 1}"
    image = "debian-11"
    server_type = "cx11"
    location = "nbg1"
    ssh_keys = [ "sgaspar@mbsgaspar" ]

    provisioner "local-exec" {
        command = <<EOT
            sleep 20
            export ANSIBLE_HOST_KEY_CHECKING=False
            # ansible-playbook -u root -i '${self.ipv4_address},' ../Ansible/update.yaml
        EOT
    }
}

# Add nodes to subnet
resource "hcloud_server_network" "rancher_node_subnet_registration" {
    count = 2
    server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
    subnet_id = hcloud_network_subnet.rancher_mgmt_subnet.id
}

# Volumes

resource "hcloud_volume" "rancher_volume-1" {
  count = 2
  name      = "rancher-volume-${count.index + 1}-1"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = true
  format    = "xfs"
}

resource "hcloud_volume" "rancher_volume-2" {
  count = 2
  name      = "rancher-volume-${count.index + 1}-2"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = true
  format    = "xfs"
}

resource "hcloud_volume" "rancher_volume-3" {
  count = 2
  name      = "rancher-volume-${count.index + 1}-3"
  size      = 50
  server_id = hcloud_server.rancher_mgmt_nodes[count.index].id
  automount = true
  format    = "xfs"
}

resource "local_file" "hosts_cfg" {
    content = templatefile(
        "${path.module}/inventory.tftpl",
        {
            user = "root"
            nodes = hcloud_server.rancher_mgmt_nodes.*.ipv4_address
        }
    )
    filename = "./inventory.yml"
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