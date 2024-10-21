variable "compatible_architectures" {
  description = "compatible_architectures"
  type        = list(string)
}

variable "compatible_layer_runtimes" {
  description = "compatible_layer_runtimes"
  type        = list(string)
}

variable "requests_layer_zip_path"{
  description = "layer zip path"
  type        = string
}

variable "lambda_layer_bucket_name"{
  description = "lambda layer bucket name"
  type        = string
}

variable "requests_layer_name"{
  description = "layer name"
  type        = string
}

variable "lambda_layer"{
  description = "lambda layer"
  type        = string
}
