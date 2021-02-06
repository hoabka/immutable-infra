all:
  hosts:
    bastion-01:
      ansible_host: ${bastion_public_ip}
      ansible_user: ${tf_remote_user}
      ansible_ssh_common_args: '-F ssh.conf -o StrictHostKeyChecking=no'
      ansible_python_interpreter: /usr/bin/env python3
    %{~ for index, private_ip in split(",", web_private_ips) ~}
    web-${format("%02d", index + 1)}:
      ansible_host: ${private_ip}
      ansible_user: ${tf_remote_user}
      ansible_ssh_common_args: '-F ssh.conf -o StrictHostKeyChecking=no'
      ansible_python_interpreter: /usr/bin/env python3
    %{~ endfor ~}
    %{~ for index, private_ip in split(",", app_private_ips) ~}
    app-${format("%02d", index + 1)}:
      ansible_host: ${private_ip}
      ansible_user: ${tf_remote_user}
      ansible_ssh_common_args: '-F ssh.conf -o StrictHostKeyChecking=no'
      ansible_python_interpreter: /usr/bin/env python3
    %{~ endfor ~}

bastion:
  hosts:
    bastion-01:

web:
  hosts:
    %{~ for index, private_ip in split(",", web_private_ips) ~}
    web-${format("%02d", index + 1)}:
    %{~ endfor ~}

app:
  hosts:
    %{~ for index, private_ip in split(",", app_private_ips) ~}
    app-${format("%02d", index + 1)}:
    %{~ endfor ~}
