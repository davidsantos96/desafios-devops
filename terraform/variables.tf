# DEFININDO VARIAVEL DA REGIAO AWS

variable "region" {
    description = "us-east-2"
    type = string
  
}

# DEFINFINDO VARIAVEL PARA RANGE DE IP SSH

variable "ssh_ip_range" {
    description = "IP ou range para acesso SSH"
    type = string
  
}