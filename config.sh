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