# python image ecr
resource "aws_ecr_repository" "ecr_app" {
  name = var.ecr_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# db images ecr
resource "aws_ecr_repository" "ecr_db" {
  name = var.ecr_db
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

