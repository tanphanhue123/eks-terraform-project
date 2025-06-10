resource "aws_ecs_service" "aws_ecs_service"{   
   for_each = { for value in var.ecs_services: value.name => value}
   name = "${var.project}-${var.env}-${each.value.name}-ecs-service"
   cluster = each.value.cluster
   deployment_controller {
     type = each.value.deployment_controller.type
   }
   dynamic "load_balancer" {
    for_each = each.value.load_balancer 
    content {
      target_group_arn  = each.value.load_balancer.target_group_arn
      container_name    = each.value.load_balancer.container_name
      container_port    = each.value.load_balancer.container_port
    }     
   }
   deployment_maximum_percent = each.value.deployment_maximum_percent
   deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent
   desired_count = each.value.desired_count
   iam_role = each.value.iam_role
   launch_type = each.value.launch_type
   network_configuration {
     subnets = each.value.network_configuration.subnet
     security_groups = each.value.network_configuration.security_group
   }
} 
