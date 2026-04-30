variable "cloud_id" {
  type      = string
  sensitive = true
}

variable "folder_id" {
  type      = string
  sensitive = true
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "image_id" {
  type = string
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "redmine"
}

variable "db_user" {
  type    = string
  default = "redmine"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "certificate_id" {
  type      = string
  sensitive = true
}
