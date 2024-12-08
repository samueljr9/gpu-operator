terraform {
  backend "s3" {
    bucket         = "aws-initiatives"
    key            = "eks.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "aws-initiatives-tf-lock-table"
  }
}
