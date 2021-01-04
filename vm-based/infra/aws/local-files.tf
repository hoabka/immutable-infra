resource "local_file" "ansible-hosts" {
  filename = "${path.cwd}/ansible-hosts.yml"
  content = templatefile("${path.cwd}/templates/ansible-hosts.tpl", {
    bastion_public_ip = aws_eip.bastion.public_ip
    web_private_ips   = join(",", aws_instance.web.*.private_ip)
    app_private_ips   = join(",", aws_instance.app.*.private_ip)
    tf_remote_user    = "ubuntu"
  })
}

resource "local_file" "ssh-conf" {
  filename = "${path.cwd}/ssh.conf"
  content  = templatefile("${path.cwd}/templates/ssh.conf.tpl", {
    bastion_public_ip            = aws_eip.bastion.public_ip
    ssh_private_key_path_bastion = "${local.private_keyname_path}/bastion.pem"
    web_private_ips              = join(",", aws_instance.web.*.private_ip)
    ssh_private_key_path_web     = "${local.private_keyname_path}/web.pem"
    app_private_ips              = join(",", aws_instance.app.*.private_ip)
    ssh_private_key_path_app     = "${local.private_keyname_path}/app.pem"
    tf_remote_user    = "ubuntu"
  })
}