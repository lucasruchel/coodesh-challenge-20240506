resource "aws_cloudwatch_dashboard" "demo-dashboard" {
  dashboard_name = "EC2-${ var.projeto }"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 4
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${ aws_instance.coodesh_ec2.id }"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "${aws_instance.coodesh_ec2.id} - CPU Utilization"
        }
      },
      {
            "type": "log",
            "x": 12,
            "y": 24,
            "width": 12,
            "height": 6,
            "properties": {
                "region": "us-east-1",
                "title": "webserver access logs",
                "query": "SOURCE 'access_log' | fields @timestamp, @message, @logStream, @log | sort @timestamp desc | limit 1000 | filter strcontains(@logStream, \"${aws_instance.coodesh_ec2.id}\")" ,
                "view": "table"
            }
        },
        {
            "type": "log",
            "x": 12,
            "y": 36,
            "width": 12,
            "height": 6,
            "properties": {
                "region": "us-east-1",
                "title": "webserver error logs",
                "query": "SOURCE 'error_log' | fields @timestamp, @message, @logStream, @log | sort @timestamp desc | limit 1000 | filter strcontains(@logStream, \"${aws_instance.coodesh_ec2.id}\"" ,
                "view": "table"
            }
        }
        ,
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 12
        height = 3

        properties = {
          markdown = "# Dashboard de Monitoramento"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 8
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${ aws_instance.coodesh_ec2.id }"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "${ aws_instance.coodesh_ec2.id } - NetworkIn"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "ec2-cpu-alarm" {
  alarm_name                = "terraform-ec2-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization reaches 80%"
  insufficient_data_actions = []
}