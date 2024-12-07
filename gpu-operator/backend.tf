terraform {
  backend "s3" {
    bucket         = "aws-initiatives"
    key            = "gpu-operator.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "aws-initiatives-tf-lock-table"
  }
}
