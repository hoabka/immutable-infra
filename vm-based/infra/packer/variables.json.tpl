${jsonencode({
    region_name            = ${region_name}
    vpc_id                 = ${vpc_id}
    subnet_id              = ${subnet_id}
    private_key            = ${private_key}
    public_key             = ${public_key}
    security_groups        = ${security_groups}
    instance_type          = ${instance_type}
    ami_desc               = ${ami_desc}
    ami_owner              = ${ami_owner}
    volume_type            = ${volume_type}
    volume_size            = ${volume_size}
    remote_user            = ${remote_user}
    ansible_dir_path       = ${ansible_dir_path}
})}
