
# Find the latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Register Deepti's public SSH key
resource "aws_key_pair" "deepti_key" {
  key_name   = "chaoscloud-deepti-key"
  public_key = file("${path.module}/deepti.pub")
}

# Register teammate's public SSH key
resource "aws_key_pair" "teammate_key" {
  key_name   = "chaoscloud-teammate-key"
  public_key = file("${path.module}/teammate.pub")
}

# Deepti's EC2 instance
resource "aws_instance" "deepti" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.chaoscloud_subnet.id
  vpc_security_group_ids = [aws_security_group.deepti_sg.id]
  key_name               = aws_key_pair.deepti_key.key_name

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name  = "chaoscloud-deepti"
    Owner = "Deepti"
  }
}

# Teammate's EC2 instance
resource "aws_instance" "teammate" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.chaoscloud_subnet.id
  vpc_security_group_ids = [aws_security_group.teammate_sg.id]
  key_name               = aws_key_pair.teammate_key.key_name

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name  = "chaoscloud-teammate"
    Owner = "Teammate"
  }
}
