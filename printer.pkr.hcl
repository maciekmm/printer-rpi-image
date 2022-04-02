source "arm-image" "raspberry_pi_os" {
  iso_checksum      = "f6e2a3e907789ac25b61f7acfcbf5708a6d224cf28ae12535a2dc1d76a62efbc"
  iso_url           = "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-01-28/2022-01-28-raspios-bullseye-armhf-lite.zip"

  // 4GB
  target_image_size = 4294967296
}

variable "wifi_ssid" {
  type    = string
}

variable "wifi_password" {
  type    = string
}

variable "ssh_public_key" {
  type = string
}

build {
  sources = ["source.arm-image.raspberry_pi_os"]

  provisioner "shell" {
    inline = [
      "wpa_passphrase \"${var.wifi_ssid}\" \"${var.wifi_password}\" | sed -e 's/#.*$//' -e '/^$/d' >> /etc/wpa_supplicant/wpa_supplicant.conf"
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /home/pi/.ssh/",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo -n \"${var.ssh_public_key}\" > /home/pi/.ssh/authorized_keys"
    ]
  }
  
  provisioner "shell" {
    inline = [
      "chown -R pi:pi /home/pi/.ssh/",
      "chmod -R 700 /home/pi/.ssh/"
    ]
  }

  provisioner "shell" {
    inline = [
      "sed '/PasswordAuthentication/d' -i /etc/ssh/sshd_config",
      "echo  >> /etc/ssh/sshd_config",
      "echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config"
    ]
  }

  # when we run in chroot we don't have access to dbus
  # and we cannot run hostnamectl
  provisioner "shell" {
    inline = [
      "echo 'pi-print-server' > /etc/hostname"
    ]
  }

  provisioner "ansible" {
    playbook_file = "/vagrant/ansible/setup.yaml"
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=1",
      "PYTHONUNBUFFERED=1",
    ]
    extra_arguments = [
      "--connection=chroot",
      "--become-user=root",
      "--user=pi",
      # Ansible needs this to find the mount path
      "-e ansible_host=${build.MountPath}"
    ]
  }
}
