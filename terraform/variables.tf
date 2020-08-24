variable region {
    description = "AWS Region"
    default = "us-east-1"
}

variable "stack" {
    description = "Nome da Stack"
    default = "terraform"
}

variable "vpc_cidr" {
    description = "CIDR da  VPC"
    default = "10.1.0.0/16"
}

variable "subnet_cidr" {
    description = "CIDR das Subnets"
    type = list
    default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "instances" {
     default = 2
     description = "No de instances"
}

variable "vm_size" {
    description = "Tipo de Instancia"
    default = "t2.micro"
}

variable "sg_source" {
    default = ["0.0.0.0/0"]
    description = "Source CIDR para o SG"
    type = list
}

variable "port_number" {
  description = "Liberacao das portas de acesso"
  default = ["22","80"]
  type = list
}
