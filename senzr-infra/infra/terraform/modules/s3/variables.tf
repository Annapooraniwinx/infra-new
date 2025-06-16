variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "file_key" {
  description = "The key (path) for the file in the S3 bucket"
  type        = string
}

variable "source_file_path" {
  description = "The local path to the file to upload"
  type        = string
}
