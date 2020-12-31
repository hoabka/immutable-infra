Host *
  User ${tf_remote_user}
  StrictHostKeyChecking no
  ControlMaster auto
  ControlPath ~/.ssh/ansible-%r@%h:%p
  ControlPersist 30m
  ConnectionAttempts=100
  ServerAliveInterval 60
  ServerAliveCountMax 5

# for bastion node
Host bastion-01
  HostName ${bastion_public_ip}
  User ${tf_remote_user}
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  LogLevel ERROR
  IdentityFile ${ssh_private_key_path_bastion}

# for web server node
%{ for index, private_ip in split(",", web_private_ips) ~}
Host web-${format("%02d", index + 1)} ${private_ip}
  HostName ${private_ip}
  User ${tf_remote_user}
  ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p -i ${ssh_private_key_path_bastion} ${tf_remote_user}@${bastion_public_ip}
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  LogLevel ERROR
  IdentityFile ${ssh_private_key_path_web}
%{ endfor ~}

# for app server node
%{ for index, private_ip in split(",", app_private_ips) ~}
Host app-${format("%02d", index + 1)} ${private_ip}
  HostName ${private_ip}
  User ${tf_remote_user}
  ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p -i ${ssh_private_key_path_bastion} ${tf_remote_user}@${bastion_public_ip}
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  LogLevel ERROR
  IdentityFile ${ssh_private_key_path_app}
%{ endfor ~}