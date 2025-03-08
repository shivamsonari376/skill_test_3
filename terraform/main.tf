provider "aws" {
  region = var.region
}

# Security Group definition
resource "aws_security_group" "sg" {
  name        = "shivam_sg"
  description = "Security group for frontend, backend, and database instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow MongoDB connections from backend instance
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all for testing; restrict to backend's private IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Database EC2 Instance
resource "aws_instance" "database" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]  # Updated reference for security group

  tags = {
    Name = "shivam_database"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y git
    yum install -y mongodb
    systemctl start mongod
    systemctl enable mongod
    # Allow MongoDB to bind to all IP addresses (including public IP)
    sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
    systemctl restart mongod
    mongo --eval 'db.createUser({user:"admin",pwd:"admin",roles:[{role:"readWrite",db:"travelmemory"}]})'
    mongo --eval 'use travelmemory'
  EOF
}

# Backend EC2 Instance
resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]  # Updated reference for security group

  tags = {
    Name = "shivam_backend"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y git
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
    yum install -y nodejs
    yum install -y npm
    cd /home/ec2-user
    git clone https://github.com/UnpredictablePrashant/TravelMemory.git
    cd TravelMemory/backend

    # Create .env file for backend
    MONGO_URI="mongodb://admin:admin@${aws_instance.database.public_ip}:27017/travelmemory"
    echo "MONGO_URI=\$MONGO_URI" > .env
    echo "PORT=3001" >> .env
  EOF
}

# Frontend EC2 Instance
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]  # Updated reference for security group

  tags = {
    Name = "shivam_frontend"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y git
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
    yum install -y nodejs
    yum install -y npm
    cd /home/ec2-user
    git clone https://github.com/UnpredictablePrashant/TravelMemory.git
    cd TravelMemory/frontend

    # Wait for the backend instance to be up and get its public IP
    BACKEND_IP=$(aws ec2 describe-instances --query "Reservations[].Instances[?Tags[?Key=='Name'&&Value=='shivam_backend']].PublicIpAddress" --output text)
    
    # Create .env file for frontend with backend public IP
    echo "REACT_APP_BACKEND_URL=http://\$BACKEND_IP:3001" > .env
  EOF
}


