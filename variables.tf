variable "repo_owner" {
  description = "The owner of the GitHub repository"
  type        = string
}

variable "repo_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "tag_name" {
  description = "The tag name for the GitHub release"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}