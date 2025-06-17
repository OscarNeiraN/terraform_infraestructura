terraform {
  required_providers {
    aws = {
        resource = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}


resource "aws_vpc" "MoscoRetai" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "vpc_MoscoRetai"
    }
}

resource "aws_internet_gateway" "igw_MoscoRetai" {
    vpc_id = aws_vpc.MoscoRetai.id
    tags = {
      Name = "igw_MoscoRetai"
    }
}
resource "aws_security_group" "vpc_default_sg" {
    name = "vpc_default_security_group"
    vpc_id = aws_vpc.MoscoRetai.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_eip" "MoscoRetai_nat_eip"{
    domain = "vpc"
}
resource "aws_eip" "MoscoRetai_nat_eip2" {
  domain = "vpc"
}
resource "aws_eip" "MoscoRetai_nat_eip3" {
  domain = "vpc"
}

######################################################################
######################################################################

resource "aws_subnet" "sub_publ1" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.0.0/20"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
        Name = "subnet_MoscoRetail_publ"
    }
}

resource "aws_subnet" "sub_priv1" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.48.0/20"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1a"
    tags = {
        Name = "subnet_MoscoRetail_priv"
    }
}

resource "aws_route_table" "rt_publ1" {
    vpc_id = aws_vpc.MoscoRetai.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_MoscoRetai.id
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
    vpc_id = aws_vpc.MoscoRetai.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.MoscoRetai_nat_gw_MoscoRetai.id
    }
    depends_on = [aws_nat_gateway.fruta_nat_gw_fruta]
    tags = {
        Name = "rt_priv1"
    }
}

resource "aws_route_table_association" "rt_priv1" {
    subnet_id = aws_subnet.sub_priv1.id
    route_table_id = aws_route_table.rt_priv1.id
}

# NAT GATEWAY

resource "aws_nat_gateway" "MoscoRetai_nat_gw_MoscoRetai" {
    allocation_id = aws_eip.MoscoRetai_nat_eip.id
    subnet_id = aws_subnet.sub_publ1.id
    tags = {
        Name = "nat_gw_MoscoRetail"
    }
}

###############################################################
########## subnet us-east-1b ##################################
###############################################################

resource "aws_subnet" "sub_publ2" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.16.0/20"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags = {
        Name = "subnet_MoscoRetai_publ2"
    }
}

resource "aws_subnet" "sub_priv2" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.64.0/20"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1b"
    tags = {
        Name = "subnet_MoscoRetai_priv2"
    }
}

resource "aws_route_table" "rt_publ2" {
    vpc_id = aws_vpc.MoscoRetai.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_MoscoRetai.id
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
    vpc_id = aws_vpc.MoscoRetai.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.MoscoRetai_nat_gw_MoscoRetai2.id
    }
    depends_on = [aws_nat_gateway.MoscoRetai_nat_gw_MoscoRetai2]
    tags = {
        Name = "rt_priv2"
    }
}

resource "aws_route_table_association" "rt_priv2" {
    subnet_id = aws_subnet.sub_priv2.id
    route_table_id = aws_route_table.rt_priv2.id
}

# NAT GATEWAY

resource "aws_nat_gateway" "MoscoRetai_nat_gw_MoscoRetai2" {
    allocation_id = aws_eip.MoscoRetai_nat_eip2.id
    subnet_id = aws_subnet.sub_publ2.id
    tags = {
        Name = "nat_gw_MoscoRetail2"
    }
}

##############################################################
########## subnet us-east-1c #################################
##############################################################

resource "aws_subnet" "sub_publ3" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.32.0/20"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1c"
    tags = {
        Name = "subnet_MoscoRetai_publ3"
    }
}

resource "aws_subnet" "sub_priv3" {
    vpc_id = aws_vpc.MoscoRetai.id
    cidr_block = "10.0.80.0/20"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1c"
    tags = {
        Name = "subnet_MoscoRetai_priv3"
    }
}

resource "aws_route_table" "rt_publ3" {
    vpc_id = aws_vpc.MoscoRetai.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_MoscoRetai.id
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
    vpc_id = aws_vpc.MoscoRetai.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.MoscoRetai_nat_gw_MoscoRetai3.id
    }
    depends_on = [aws_nat_gateway.MoscoRetai_nat_gw_MoscoRetai3]
    tags = {
        Name = "rt_priv3"
    }
}

resource "aws_route_table_association" "rt_priv3" {
    subnet_id = aws_subnet.sub_priv3.id
    route_table_id = aws_route_table.rt_priv3.id
}

# NAT GATEWAY

resource "aws_nat_gateway" "MoscoRetai_nat_gw_MoscoRetai3" {
    allocation_id = aws_eip.MoscoRetai_nat_eip3.id
    subnet_id = aws_subnet.sub_publ3.id
    tags = {
        Name = "nat_gw_MoscoRetail3"
    }
}





