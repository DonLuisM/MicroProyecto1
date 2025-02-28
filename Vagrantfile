# -*- mode: ruby -*- 
# vi: set ft=ruby : 

Vagrant.configure("2") do |config| 
  if Vagrant.has_plugin? "vagrant-vbguest" 
    config.vbguest.no_install  = true 
    config.vbguest.auto_update = false 
    config.vbguest.no_remote   = true 
  end 
  
  # config.vm.provision "shell", path: "scriptGeneral.sh"

  config.vm.define :haproxy do |haproxy|
    haproxy.vm.box = "bento/ubuntu-22.04"
    haproxy.vm.network :private_network, ip: "192.168.100.10"
    haproxy.vm.hostname = "haproxy"
    haproxy.vm.provision "shell", path: "scriptHaproxy.sh"
  end
  
  config.vm.define :serverVM1 do |serverVM1|
    serverVM1.vm.box = "bento/ubuntu-22.04"
    serverVM1.vm.network :private_network, ip: "192.168.100.11"
    serverVM1.vm.hostname = "serverVM1"
    serverVM1.vm.synced_folder "syncFold", "/home/vagrant/syncFold"
    serverVM1.vm.provision "shell", path: "script1.sh"
  end

  config.vm.define :serverVM2 do |serverVM2|
    serverVM2.vm.box = "bento/ubuntu-22.04"
    serverVM2.vm.network :private_network, ip: "192.168.100.12"
    serverVM2.vm.hostname = "serverVM2"
    serverVM2.vm.synced_folder "syncFold", "/home/vagrant/syncFold"
    serverVM2.vm.provision "shell", path: "script2.sh"
  end
end 