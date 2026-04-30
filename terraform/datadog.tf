terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  site    = var.datadog_site
}

resource "datadog_monitor" "app_http_check" {
  name = "Project 77 HTTP check"
  type = "service check"

  query = "\"http.can_connect\".over(\"instance:web-app\").last(2).count_by_status()"

  message = "Application is not responding"

  monitor_thresholds {
    critical = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5
}
