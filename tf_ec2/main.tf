data "aws_ami" "linux_img" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.202*-x86_64-gp2"]
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.linux_img.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  availability_zone = "us-east-2b"
  vpc_security_group_ids = ["sg-03b7508e9863d88e0"]

  subnet_id = "subnet-0a1966b0921639f18"  
  key_name = "ec2"

  user_data = <<EOF
#!/bin/bash
yum install git -y
su ec2-user -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash; . ~/.nvm/nvm.sh; nvm install 16; cd ~/; git clone https://github.com/rearc/quest.git; cd ~/quest; npm install package.json; nohup node src/000.js &'
touch /tmp/done.txt
EOF

  tags = {
    Name = "QuestApp"
  }
}
