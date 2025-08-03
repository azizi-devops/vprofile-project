variable "AWS_REGION" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}


variable "ZONE1" {
  description = "The first availability zone"
  default     = "us-east-1a"
}


variable "ZONE2" {
  description = "The second availability zone"
  default     = "us-east-1b"
}


variable "ZONE3" {
  description = "The third availability zone"
  default     = "us-east-1c"
}


variable "VPC_NAME" {
  description = "Name of the VPC"
  default     = "vprofile-vpc"
}


variable "VPC_CIDR" {
  description = "CIDR block for the VPC"
  default     = "172.21.0.0/16"
}


variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 1
}


variable "PUBLIC_KEY_PATH" {
  description = "Path to the public key"
  default     = "vprofilekey.pub"
}


variable "PRIVATE_KEY_PATH" {
  description = "Name of the SSH key pair"
  default     = "vprofilekey"
}


variable "USERNAME" {
  description = "Username for the EC2 instance"
  default     = "ubuntu"
}


variable "MYIP" {
  description = "Your public IP address for security group rules"
  default     = "95.223.185.204/32"
}


variable "rmquser" {
  description = "Username for the rabbitMQ"
  default     = "rabbit"
}


variable "rmqpass" {
  description = "Password for the rabbitMQ"
  default     = "Hani5760009281*"
}


variable "dbuser" {
  description = "Username for the database"
  default     = "admin"
}


variable "dbpass" {
  description = "Password for the database"
  default     = "admin123"
}


variable "dbname" {
  description = "Name of the database"
  default     = "accounts"

}


variable "pubSub1CIDR" {
  description = "CIDR block for the first Pub/Sub service"
  default     = "172.21.1.0/24"

}


variable "pubSub2CIDR" {
  description = "CIDR block for the second Pub/Sub service"
  default     = "172.21.2.0/24"
}


variable "pubSub3CIDR" {
  description = "CIDR block for the third Pub/Sub service"
  default     = "172.21.3.0/24"
}


variable "privSub1CIDR" {
  description = "CIDR block for the fourth Pub/Sub service"
  default     = "172.21.4.0/24"
}


variable "privSub2CIDR" {
  description = "CIDR block for the fifth Pub/Sub service"
  default     = "172.21.5.0/24"
}


variable "privSub3CIDR" {
  description = "CIDR block for the sixth Pub/Sub service"
  default     = "172.21.6.0/24"
}


variable "PROJECT" {
  description = "Project name for tagging resources"
  default     = "vprofile"
}