resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}



### life-cycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "bucklifecycle" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...
     noncurrent_version_expiration {
      noncurrent_days = 2
    }
    status = "Enabled"
  }

  
}
### enable versioning to see revision history of statefiles

resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

  }
}
resource "aws_s3_bucket_public_access_block" "public_access" {
   bucket = aws_s3_bucket.terraform_state.id
   block_public_acls = true
   block_public_policy = true
   ignore_public_acls = true
   restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}