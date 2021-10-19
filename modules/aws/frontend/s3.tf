resource "aws_s3_bucket" "images_bucket" {
  bucket = "${var.env}-${var.images_s3_bucket_name}"
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    // 失効した削除マーカーまたは不完全なマルチパートアップロードを削除する
    abort_incomplete_multipart_upload_days = 7

    // 古いバージョンは30日で削除
    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "images_bucket" {
  comment = "${aws_s3_bucket.images_bucket.bucket} origin access identity"
}

data "aws_iam_policy_document" "read_images" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.images_bucket.arn}/*"]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.images_bucket.iam_arn]
      type        = "AWS"
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.images_bucket.arn]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.images_bucket.iam_arn]
      type        = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "read_images" {
  bucket = aws_s3_bucket.images_bucket.id
  policy = data.aws_iam_policy_document.read_images.json
}

resource "aws_s3_bucket" "images_access_logs" {
  bucket        = "${var.env}-${var.images_access_logs_s3_bucket_name}"
  force_destroy = true

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
  }
}
