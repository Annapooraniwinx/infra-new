output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.bucket
}

output "file_url" {
  description = "URL of the uploaded file"
  value       = aws_s3_object.my_file.url
}
