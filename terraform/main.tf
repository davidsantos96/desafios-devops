provider "aws" {
  region = var.region
}

# CRIANDO E CONFIGURANDO MAQUINA VIRTUAL
resource "aws_instance" "web" {
    ami = "ami-06c8f2ec674c67112"
    instance_type = "t2.micro"

# ASSOCIANDO INSTANCIA AO SECURITY GROUP
    vpc_security_group_ids = [  ]

# SCRIPT DE AUTOMAÇÃO DE INSTALAÇÃO DO DOCKER E APACHE
    user_data = <<-EOF
        #!/bin/bash
        apt update && apt install -y docker.io
        systenctl start docker
        docker run -d -p 80:80 httpd
    EOF

    tags = {
      Name = "WebServer"
    }
  
}

# CRIANDO E CONFIGURANDO SECURITY GROUP PARA ACESSO AS PORTAS SSH E TCP
resource "aws_security_group" "web_sg" {
    name_prefix = "web-sg-"

# PERMITINDO ACESSO PARA TODOS NA PORTA 80

    ingress {
        from_port =80
        to_port =80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
# PERMITINDO ACESSO PARA TODOS NA PORTA 443

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
# PERMITINDO ACESSO SOMENTE PARA RANGE DEFINIDO NA PORTA 22 SSH
  
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.ssh_ip_range]
    }

# TRAFEGO DE SAIDA PARA QUALQUER DESTINO
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}