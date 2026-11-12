
# Deepti's EC2 security group
resource "aws_security_group" "deepti_sg" {
  name_prefix = "chaoscloud-deepti-"
  description = "CHAOSCLOUD application security group"
  vpc_id      = aws_vpc.chaoscloud_vpc.id

  ingress {
    description = "SSH from Deepti"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.deepti_ssh_cidr]
  }

  ingress {
    description = "Public CHAOSCLOUD application"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Node Exporter from monitoring instance"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.teammate_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chaoscloud-deepti-sg"
  }
}

# Teammate's EC2 security group
resource "aws_security_group" "teammate_sg" {
  name_prefix = "chaoscloud-teammate-"
  description = "CHAOSCLOUD monitoring security group"
  vpc_id      = aws_vpc.chaoscloud_vpc.id

  ingress {
    description = "SSH from teammate"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.teammate_ssh_cidr]
  }

  ingress {
    description = "Public Grafana dashboard"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Public Prometheus dashboard"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Public Alertmanager dashboard"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chaoscloud-teammate-sg"
  }
}

# Allow Prometheus to scrape application metrics
resource "aws_security_group_rule" "app_metrics" {
  type                     = "ingress"
  description              = "Application metrics from monitoring instance"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.deepti_sg.id
  source_security_group_id = aws_security_group.teammate_sg.id
}
