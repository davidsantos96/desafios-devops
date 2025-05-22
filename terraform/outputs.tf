# EXIBINDO IP PUBLICO DA INSTANCIA

output "instance_ip" {
    description = "IP publico da instancia"
    value = aws_instance.web.public_ip
  
}