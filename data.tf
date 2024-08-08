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

resource "null_resource" "clone" {
  triggers = {
    sha = data.github_branch.branch.sha
  }

  provisioner "local-exec" {
    command = "rm -rf ${path.module}/${var.repo_name} || echo; git clone ${github_repository.repo.ssh_url} ${path.module}/${var.repo_name}"
  }
}

resource "local_file" "foo" {
  content    = data.github_branch.branch.sha
  filename   = "${path.module}/${var.repo_name}/.git_sha"
  depends_on = [null_resource.clone]
}

# Archive multiple files and exclude file.
data "archive_file" "release_files" {
  type        = "zip"
  output_path = "${path.module}/${var.repo_name}.zip"
  source_dir  = "${path.module}/${var.repo_name}"
  excludes    = [path.module]
}
