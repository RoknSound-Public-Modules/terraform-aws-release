resource "github_release" "release" {
  repository       = data.github_repository.repo.name
  tag_name         = var.tag_name
  target_commitish = data.github_ref.ref.ref
  draft            = false
  prerelease       = false
}

resource "aws_s3_object" "release" {
  bucket = data.aws_s3_bucket.bucket.bucket
  key    = "${var.repo_name}.${var.tag_name}.zip"
  source = data.archive_file.release_files.output_path
  depends_on = [
    data.archive_file.release_files
  ]
}