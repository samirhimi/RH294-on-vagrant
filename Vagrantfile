NUM_NODE = 4
IP_NW = "192.168.2."
MANAGED_IP_START = 200
DISK_GBS= 32


Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos9s"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.graphics_type = 'none'
    libvirt.default_prefix = "managed_"
    libvirt.memory = 2048
    libvirt.cpus = 1
    libvirt.storage :file, :size => "#{DISK_GBS}G"
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