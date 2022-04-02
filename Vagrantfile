# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.synced_folder "./", "/vagrant", disabled: false
  config.vm.provision "build-env", type: "shell", :path => "scripts/provision-build-env.sh", privileged: false
  config.vm.provision "install-ansible", type: "shell", :path => "scripts/provision-ansible.sh", privileged: false
  config.vm.provision "packer-plugin-arm-image", type: "shell", :path => "scripts/provision-packer-plugin-arm-image.sh", privileged: false
  config.vm.provision "build-image", type: "shell", :path => "scripts/provision-build-image.sh", privileged: false, env: {
    "PACKERFILE" => "printer.pkr.hcl",
    "PKR_VAR_wifi_ssid" => ENV["WIFI_SSID"],
    "PKR_VAR_wifi_password" => ENV["WIFI_PASSWORD"],
    "PKR_VAR_ssh_public_key" => ENV["SSH_PUBLIC_KEY"]
  }
end
