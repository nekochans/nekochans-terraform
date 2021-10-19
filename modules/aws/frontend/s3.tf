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

// ここから下は Next.js 版に変わった後でも残す
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
