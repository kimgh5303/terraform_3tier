resource "aws_security_group" "asg_app_sg" {
  description = "ASG APP Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = {http = var.ingress_rule["http"]}

    content {
        description = ingress.value["description"]
        from_port   = ingress.value["from_port"]
        to_port     = ingress.value["to_port"]
        protocol    = ingress.value["protocol"]
        security_groups = [aws_security_group.alb_app_sg.id]
    }
  }

  dynamic "ingress" {
    for_each = {https = var.ingress_rule["https"]}

    content {
        description  = ingress.value["description"]
        from_port    = ingress.value["from_port"]
        to_port      = ingress.value["to_port"]
        protocol     = ingress.value["protocol"]
        security_groups = [aws_security_group.alb_app_sg.id]
    }
  }

  dynamic "ingress" {
    for_each = {http = var.ingress_rule["ssh"]}

    content {
        description = ingress.value["description"]
        from_port   = ingress.value["from_port"]
        to_port     = ingress.value["to_port"]
        protocol    = ingress.value["protocol"]
        security_groups = [aws_security_group.asg_web_sg.id]
    }
  }

  dynamic "egress" {
    for_each = [var.egress_rule]

    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = format("%s-asg-app-sg", var.tags["name"])
  }
}