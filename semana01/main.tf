 provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "labVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "labVPC"
  }
}

resource "aws_internet_gateway" "labIGW" {
  vpc_id = aws_vpc.labVPC.id
  tags = {
    Name = "labIGW"
  }
}

resource "aws_subnet" "publicLabSubnet" {
  vpc_id                  = aws_vpc.labVPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicLabSubnet"
  }
}

resource "aws_route_table" "labRouteTable" {
  vpc_id = aws_vpc.labVPC.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.labIGW.id
  }
  tags = {
    Name = "labRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.publicLabSubnet.id
  route_table_id = aws_route_table.labRouteTable.id
}

resource "aws_instance" "web_server" {
  ami                  = "ami-0885b1f6bd170450c"
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.publicLabSubnet.id
  security_groups      = [aws_security_group.http_sg.id]
  iam_instance_profile = "LabInstanceProfile"

  tags = {
    Name = "web_server"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Atualiza os pacotes e garante que o SSM Agent está ativo
              yum update -y
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent

              # Cria o Hello World no diretório do usuário padrão
              echo "Hello World! Instancia privada acessada via SSM em $(date)" > /home/ec2-user/hello_world.txt
              
              # Log de execução para você conferir depois
              echo "User data executado com sucesso em $(date)" >> /var/log/user-data-status.log
              EOF

}

resource "aws_security_group" "http_sg" {
  name        = "http_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.labVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}