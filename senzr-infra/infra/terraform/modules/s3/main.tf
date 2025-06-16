provider "aws" {
  region = "us-west-2"  # Modify this to your AWS region
}

# Define an S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"  # Replace this with a unique bucket name
  acl    = "private"  # Set the ACL (access control) for the bucket

  versioning {
    enabled = true  # Enable versioning for the bucket
  }

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Production"
  }
}

# Define a bucket object (file) to upload to the S3 bucket
resource "aws_s3_object" "my_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "path/to/file.txt"  # Replace with the desired path and file name in the S3 bucket
  source = "path/to/local/file.txt"  # Replace with the local path to the file you want to upload
  acl    = "private"  # Set the ACL (access control) for the file
}
