# ssh keys
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "default-ssh-privkey" {
    content = tls_private_key.default.private_key_pem
    filename = "${path.cwd}/default-id_rsa"
    file_permission = "0600"
}

resource "local_file" "default-ssh-pubkey" {
    content  = tls_private_key.default.public_key_openssh
    filename = "${path.cwd}/default-id_rsa.pub"
    file_permission = "0644"
}

# Output: The dynamically created openssh public key
output "default_ssh_public_key" {
  value = tls_private_key.default.public_key_openssh
  sensitive = false
}

# Output: The dynamically created openssh private key
output "default_ssh_private_key" {
  value = tls_private_key.default.private_key_pem
  sensitive = true
}
