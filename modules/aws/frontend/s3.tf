resource "aws_s3_bucket" "frontend" {
  bucket        = "${var.env}-${var.frontend_s3_bucket_name}"
  force_destroy = true
}

resource "aws_cloudfront_origin_access_identity" "frontend_origin_access_identity" {
  comment = "access-identity-S3-${var.env}-${var.frontend_s3_bucket_name}"
}

data "aws_iam_policy_document" "frontend_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.frontend_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend_s3_policy.json
}

resource "aws_s3_bucket" "frontend_access_logs" {
  bucket        = "${var.env}-${var.frontend_access_logs_s3_bucket_name}"
  force_destroy = true
}

data "aws_iam_policy_document" "frontend_access_logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.frontend_access_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.frontend_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_access_logs" {
  bucket = aws_s3_bucket.frontend_access_logs.id
  policy = data.aws_iam_policy_document.frontend_access_logs.json
}

