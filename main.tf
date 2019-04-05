provider "aws" {
    region  = "us-east-1"
    profile = "darkkc"
}

resource "aws_ecs_cluster" "wp" {
  name = "wordpress"
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = "${file("wordpress.json")}"

  # volume {
  #   name      = "wordpress-storage"
  #   host_path = "/ecs/wordpress-storage"
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  # }
}

# resource "aws_lb_target_group" "wordpress" {  
#   name                  = "wordpress-lbtg"  
#   port                  = "80"  
#   protocol              = "HTTP"  
#   vpc_id                = "vpc-5c1c7c3b"   
#   tags {    
#     name                = "wordpress-lbtg"    
#   }   
#   stickiness {    
#     type                = "lb_cookie"    
#     cookie_duration     = 1800    
#     enabled             = "true"  
#   }   
#   health_check {    
#     healthy_threshold   = 3    
#     unhealthy_threshold = 10    
#     timeout             = 5    
#     interval            = 10    
#     path                = "/"    
#     protocol            = "HTTP"
#     port                = "80"  
#   }
# }


resource "aws_ecs_service" "wordpress" {
  name            = "wordpress"
  launch_type     = "FARGATE"
  cluster         = "${aws_ecs_cluster.wp.id}"
  task_definition = "${aws_ecs_task_definition.wordpress.arn}"
  desired_count   = 1
#   iam_role        = "${aws_iam_role.foo.arn}"
#   depends_on      = ["aws_iam_role_policy.foo"]

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }

  network_configuration {
    subnets = ["subnet-f704f1be","subnet-40898c18"]
  }

  # load_balancer {
  #   target_group_arn = "${aws_lb_target_group.wordpress.arn}"
  #   container_name   = "wordpress"
  #   container_port   = 80
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  # }
}