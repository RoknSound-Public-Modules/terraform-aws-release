resource "aws_s3_object" "release" {
  bucket = data.aws_s3_bucket.bucket.bucket
  key    = "${var.repo_name}.zip"
  source = data.archive_file.release_files.output_path
  depends_on = [
    data.archive_file.release_files
  ]
}