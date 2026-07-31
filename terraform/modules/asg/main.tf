resource "aws_launch_template" "app_spot" {
  name_prefix   = "spot-app-template"
  image_id      = var.ami_id # Replace with your target standard AMI (e.g., Amazon Linux 2023)
  user_data = var.userdata_base64
  key_name = var.key_name
  iam_instance_profile {
    name = var.instance_profile
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups = var.security_group_ids # References your private app SG
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.node_name_tag 
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name_prefix         = "k8s-asg-"
  min_size            = var.min_instances
  max_size            = var.max_instances
  desired_capacity    = var.min_instances # Initial capacity matches the minimum
  vpc_zone_identifier = var.subnet_ids # Spread across AZs

  #target_group_arns   = var.target_group_arns # Hooks up to your ALB Target Group
  #health_check_type   = "ELB"
  #health_check_grace_period = 300

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app_spot.id
        version            = "$Latest"
      }

      # Best Practice: Diversify Spot instance types to minimize the blast radius of AWS reclaims
      override {
        instance_type = "t3.micro"
      }
      override {
        instance_type = "t2.micro"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 0 # Zero guaranteed On-Demand instances
      on_demand_percentage_above_base_capacity = 0 # 0% On-Demand means 100% Spot allocation above base
      
      # Automatically selects the most available Spot pools to mitigate interruption risk
      spot_allocation_strategy  = "price-capacity-optimized"
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity] # Prevents Terraform applies from overriding running capacity adjustments
  }
}
