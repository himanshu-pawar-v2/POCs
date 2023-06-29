variable "lambda_function_name" {
  type    = string
  default = "rb-lambda-function"
}

variable "log_group_name" {
  type    = string
  default = "rb-logs-group"
}

variable "log_stream_name" {
  type    = string
  default = "rb-log-stream"
}
