data "github_repository" "repo" {
  full_name = "${var.repo_owner}/${var.repo_name}"
}

data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

data "github_branch" "branch" {
  branch     = data.github_repository.repo.default_branch
  repository = data.github_repository.repo.name
}

# Archive multiple files and exclude file.
data "archive_file" "release_files" {
  type        = "zip"
  output_path = "${path.module}/${var.repo_name}.zip"
  source_dir  = "${path.module}/${var.repo_name}"
  depends_on  = [null_resource.clone]
}
