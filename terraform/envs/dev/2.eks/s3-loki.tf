module "s3_bucket_chunks" {
  source = "../../../modules/s3"

  s3_bucket = {
    name       = "${var.project}-${var.env}-loki-chunks"
    versioning = "Enabled"
  }
}

module "s3_bucket_ruler" {
  source = "../../../modules/s3"

  s3_bucket = {
    name       = "${var.project}-${var.env}-loki-ruler"
    versioning = "Enabled"
  }
}
