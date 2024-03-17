resource "aws_codedeploy_app" "nyu-vip-codedeploy-app" {
  name             = "${var.project_name}-codedeploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "deployment-group" {
  app_name               = aws_codedeploy_app.nyu-vip-codedeploy-app.name
  deployment_group_name  = "nyu-vip-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = var.role_arn

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }

  load_balancer_info {

    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.aws_lb_listener_arn
      }

      target_group {
        name = var.alb_target_group_name[0]
      }
      target_group {
        name = var.alb_target_group_name[1]
      }
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"

  }

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE", # trigger a rollback on deployment failure event
    ]
  }


}
