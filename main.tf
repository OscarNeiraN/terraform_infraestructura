terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#################################################################
########## CREACION DE VPC ######################################
#################################################################

resource "aws_vpc" "vpc_fruta" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc_fruta"
    }
}

resource "aws_internet_gateway" "igw_fruta" {
    vpc_id = aws_vpc.vpc_fruta.id
    tags = {
        Name = "igw_fruta"
    }
}

resource "aws_security_group" "vpc_default_sg" {
  name        = "vpc_default-security-group"
  description = "Grupo de seguridad predeterminado de la VPC"
  vpc_id      = aws_vpc.vpc_fruta.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################################################
########## subnet us-east-1a ##############################
###########################################################

resource "aws_subnet" "sub_publ1" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
        Name = "subnet_fruta_publ"
    }
}

resource "aws_subnet" "sub_priv1" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1a"
    tags = {
        Name = "subnet_fruta_priv"
    }
}

resource "aws_route_table" "rt_publ1" {
    vpc_id = aws_vpc.vpc_fruta.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_fruta.id
    }
    tags = {
        Name = "rt_publ1"
    }
}

resource "aws_route_table_association" "rt_publ1" {
    subnet_id = aws_subnet.sub_publ1.id
    route_table_id = aws_route_table.rt_publ1.id
}

resource "aws_route_table" "rt_priv1" {
    vpc_id = aws_vpc.vpc_fruta.id
    tags = {
        Name = "rt_priv1"
    }
}

resource "aws_route_table_association" "rt_priv1" {
    subnet_id = aws_subnet.sub_priv1.id
    route_table_id = aws_route_table.rt_priv1.id
}


###############################################################
########## subnet us-east-1b ##################################
###############################################################

resource "aws_subnet" "sub_publ2" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags = {
        Name = "subnet_fruta_publ2"
    }
}

resource "aws_subnet" "sub_priv2" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1b"
    tags = {
        Name = "subnet_fruta_priv2"
    }
}

resource "aws_route_table" "rt_publ2" {
    vpc_id = aws_vpc.vpc_fruta.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_fruta.id
    }
    tags = {
        Name = "rt_publ2"
    }
}

resource "aws_route_table_association" "rt_publ2" {
    subnet_id = aws_subnet.sub_publ2.id
    route_table_id = aws_route_table.rt_publ2.id
}

resource "aws_route_table" "rt_priv2" {
    vpc_id = aws_vpc.vpc_fruta.id
    tags = {
        Name = "rt_priv2"
    }
}

resource "aws_route_table_association" "rt_priv2" {
    subnet_id = aws_subnet.sub_priv2.id
    route_table_id = aws_route_table.rt_priv2.id
}


##############################################################
########## subnet us-east-1c #################################
##############################################################

resource "aws_subnet" "sub_publ3" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1c"
    tags = {
        Name = "subnet_fruta_publ3"
    }
}

resource "aws_subnet" "sub_priv3" {
    vpc_id = aws_vpc.vpc_fruta.id
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1c"
    tags = {
        Name = "subnet_fruta_priv3"
    }
}

resource "aws_route_table" "rt_publ3" {
    vpc_id = aws_vpc.vpc_fruta.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_fruta.id
    }
    tags = {
        Name = "rt_publ3"
    }
}

resource "aws_route_table_association" "rt_publ3" {
    subnet_id = aws_subnet.sub_publ3.id
    route_table_id = aws_route_table.rt_publ3.id
}

resource "aws_route_table" "rt_priv3" {
    vpc_id = aws_vpc.vpc_fruta.id
    tags = {
        Name = "rt_priv3"
    }
}

resource "aws_route_table_association" "rt_priv3" {
    subnet_id = aws_subnet.sub_priv3.id
    route_table_id = aws_route_table.rt_priv3.id
}


################################################################
########## GRUPOS DE SEGURIDAD BALANCEADOR DE CARGA ############
################################################################

resource "aws_security_group" "seguridad_load_balancer" {
    name = "seguridad-load-balacer"
    description = "Seguridad para el load balacer"
    vpc_id = aws_vpc.vpc_fruta.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


#######################################################
########## GRUPOS DE SEGURIDAD EC2 BASTION HOST #######
#######################################################
resource "aws_security_group" "seguridad-ec2-bastion-host" {
    name = "seguridad-ec2"
    description = "Seguridad para la instancia EC2"
    vpc_id = aws_vpc.vpc_fruta.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

#######################################################
########## GRUPOS DE SEGURIDAD EC2 WEB ################
resource "aws_security_group" "seguridad-ec2-expuesta" {
    name = "seguridad-ec2-expuesta"
    description = "Seguridad para la instancia EC2 expuesta"
    vpc_id = aws_vpc.vpc_fruta.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_security_group_rule" "asociacion_balanceador_ec2_sg" {
    type = "ingress"
    security_group_id = aws_security_group.seguridad-ec2-expuesta.id
    source_security_group_id = aws_security_group.seguridad_load_balancer.id
    from_port = 80
    to_port = 80
    protocol = "tcp"
}


#############################################
########## INSTANCIAS EC2 ###################
#############################################


resource "aws_instance" "ec2_publ_1" {
    ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.sub_publ1.id
    vpc_security_group_ids = [aws_security_group.seguridad-ec2-expuesta.id]
    key_name = "key_fruta"
    tags = {
        Name = "ec2_publ_1"
    }
}
output "mensaje_1" {
  value = "ip de la instancia publica 1, subnet 10.0.1.0/24"
}

output "instancia_publ_1" {
  value = [aws_instance.ec2_publ_1.public_ip , aws_instance.ec2_publ_1.private_ip ]
}


resource "aws_instance" "ec2_priv_2" {
    ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.sub_priv2.id
    vpc_security_group_ids = [aws_security_group.seguridad-ec2-expuesta.id]
    key_name = "key_fruta"
    tags = {
        Name = "ec2_priv_2"
    }
}

output "mensaje_2" {
  value = "ip de la instancia privada 2, subnet 10.0.4.0/24"
}

output "instancia_priva_2" {
    value = [aws_instance.ec2_priv_2.public_ip , aws_instance.ec2_priv_2.private_ip ]
}
