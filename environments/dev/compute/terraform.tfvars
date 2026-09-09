vpc_name = "test-lab-vpc-dev"

tags = {
  ManagedBy   = "terraform"
  Environment = "dev"
}

# Here we define our security groups 
security_groups = {
  asg = {
    name        = "asg"
    description = "Allow HTTP/HTTPS from ALB"
    ingress_rules = {
      https = {
        from_port                    = 443
        to_port                      = 443
        ip_protocol                  = "tcp"
        description                  = "HTTPS from ALB"
        referenced_security_group_id = "ALB:app"
      }
      http = {
        from_port                    = 80
        to_port                      = 80
        ip_protocol                  = "tcp"
        referenced_security_group_id = "ALB:app"
        description                  = "HTTP from ALB"
      }
      tomcat = {
        from_port                    = 8080
        to_port                      = 8080
        ip_protocol                  = "tcp"
        referenced_security_group_id = "ALB:app"
        description                  = "Tomcat"
      }
      ssh = {
        from_port   = 22
        ip_protocol = "tcp"
        cidr_ipv4   = "120.29.76.187/32"
        description = "ssh"
      }
    }
    egress_rules = {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }

  # INPUT NEW SG HERE
}

use_name_prefix = false

###############################################################################
########################## ALB terraform tfvars ###############################
###############################################################################

create_security_group      = true
security_group_name        = "alb-security-group"
enable_deletion_protection = false
albs = {
  app = {
    name               = "dev-app-alb"
    internal           = false
    load_balancer_type = "application"
    subnets            = []
    # ALB security group upon creation
    security_group_ingress_rules = {} #ingress rules are stated in security-group.tf for ALB to be able to listen from CloudFront ONLY
    security_group_egress_rules = {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }

    listeners = {
      http = {
        port     = 80
        protocol = "HTTP"
        forward = {
          target_group_key = "app"
        }
      }
    }
    target_groups = {
      app = {
        name              = "dev-app-tg"
        port              = 80
        protocol          = "HTTP"
        target_type       = "instance"
        create_attachment = false
        health_check = {
          enabled             = true
          path                = "/health"
          protocol            = "HTTP"
          port                = "traffic-port"
          healthy_threshold   = 3
          unhealthy_threshold = 3
          timeout             = 5
          interval            = 30
          matcher             = "200"
        }
      }
    }
    security_group_keys = [
      "alb-security-group"
    ]
  }
}


################################################################################
########################## ASG terraform tfvars ################################
################################################################################

aws_region   = "ap-southeast-1"
project_name = "project-aws-infra"
environment  = "dev"

# --- Networking ---
# Fill these in from your VPC module outputs / remote state.
vpc_id = "vpc-REPLACE_ME"
#private_subnet_ids     = ["subnet-REPLACE_PRIVATE_A", "subnet-REPLACE_PRIVATE_B"]
#public_subnet_ids      = ["subnet-REPLACE_PUBLIC_A", "subnet-REPLACE_PUBLIC_B"]
#asg_security_group_ids = ["sg-REPLACE_ASG_SG"]
#alb_security_group_ids = ["sg-REPLACE_ALB_SG"]

# --- ALB ---
alb_certificate_arn = ""

# --- ASG / launch template ---
ami_id        = "ami-0031daad7993ba99f"
instance_type = "t4g.small"
key_name      = null

min_size         = 1
max_size         = 2
desired_capacity = 1

iam_role_policies = {
  AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

target_cpu_utilization = 50