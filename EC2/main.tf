#
# David Clark
# Created on 11/8/23
#

# this is where we are creating the EC2 instance - in this case we are using the AWS plugin
provider "aws" {
    # change to whatever region you want to use
    region = "us-east-1"
    access_key = "place_value_here_from_account"
    secret_key = "place_value_here_from_account"
}
# this creates the key pair we need to be able to ssh into our EC2 instance 
# If you don't already have a key pair on your device then you will need to create one
#
# ssh-keygen -t rsa -b 2048 -f "~/.ssh/my_aws_key"
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/my_aws_key.pub")
}
# this is the resource we want to create - in this instance we are creating EC2 instance(t2.micro)
# If you change this you will need to change the ami to the instance you want to create
resource "aws_instance" "ubuntu_t2_micro" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    key_name      = aws_key_pair.deployer.key_name
    tags = {
        Name = "terraform_basics"
    }
}
output "instance_ips" {
  value = aws_instance.ubuntu_t2_micro.*.public_ip
}
# example of ssh'ing to the EC2 instance
# You will need to log into your aws account to get the DNS name or IP to log in *UPDATED to output the public IP to console so you don't need to log in
#ssh -i "my_aws_key"  ubuntu@ec2-54-197-221-233.compute-1.amazonaws.com