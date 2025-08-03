resource "aws_key_pair" "vprofilekey" {
  key_name   = "vprofilekey"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILh+gFPW+vQSQysGzrypgxZLa1vzgYnl7IDJ3ufqIMes hani@samsung"
}