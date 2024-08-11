# Ansible Labs for RH294


## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

This project will help you to run and configure a lab similar to the Red Hat automation RH294 Labs using vagrant

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your machine.

### Prerequisites

Vagrant running 4 VMs of Centos or Fedora

Create Vagrantfile and config.sh files

In this example I used centos stream version 9

Download the vagrant image using the command below

```
vagrant box add generic/centos9s

```
Create a Vagrantfile

```
vim Vagrantfile 
```
Paste the content below

```
NUM_NODE = 4
IP_NW = "192.168.2."
MANAGED_IP_START = 200



Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos9s"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.graphics_type = 'none'
    libvirt.default_prefix = "managed_"
    libvirt.memory = 2048
    libvirt.cpus = 1
    libvirt.qemu_use_session = false
  end


  (0..NUM_NODE-1).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}"
      node.vm.provision "shell", path: "config.sh"
      node.vm.network :private_network, ip: IP_NW + "#{MANAGED_IP_START + i}"
    end
  end
end
```
To verify the syntax of Vagrantfile run

```
vagrant validate
```
Then create the config.sh file, that will install all the necessary updates and packages

```
vim config.sh
```
```
#!/bin/sh

echo "Managed Node Preparation ..."

yum install -y epel-release wget vim
yum makecache
yum update -y
yum install -y python3 bind-utils

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

PASS=$(echo "ansible" | openssl passwd -1 -stdin)
useradd -p "$PASS" ansible
cat <<EOF > /etc/sudoers.d/ansible
ansible ALL=NOPASSWD: ALL
EOF

cat <<EOF > /etc/hosts
192.168.2.200 node0.lab.local
192.168.2.201 node1.lab.local
192.168.2.202 node2.lab.local
192.168.2.203 node3.lab.local
EOF
```
After that, run

```
vagrant up
```
This command will start bootstrapping all the VMs with the defined configurations in config.sh file

### Installing

A step by step series of examples that tell you how to get a development env running.

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo.

## Usage <a name = "usage"></a>

Add notes about how to use the system.
