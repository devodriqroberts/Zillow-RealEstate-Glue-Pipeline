variable "account_id" {
  type = string
  description = "AWS Caller Identity current account id."
}

variable "server_side_encryption_algorithm" {
  type = string
  description = "Server-side encryption algorithm to use"
  default = "AES256"
}