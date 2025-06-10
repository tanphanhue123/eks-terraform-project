resource "aws_ecs_cluster" "aws_ecs_cluster" {
    name = "${var.project}-${var.env}-ecs-cluster"
    tags = {
        ECS = "Yes"
        Compute_type = "EC2"
    }
}