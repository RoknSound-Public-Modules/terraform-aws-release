resource "null_resource" "clone" {
  triggers = {
    sha = data.github_branch.branch.sha
  }

  provisioner "local-exec" {
    command = "rm -rf ${path.module}/${var.repo_name} || echo; git clone ${data.github_repository.repo.ssh_clone_url} ${path.module}/${var.repo_name}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${path.module}/${var.repo_name}/.git"
  }
}

resource "local_file" "foo" {
  content    = data.github_branch.branch.sha
  filename   = "${path.module}/${var.repo_name}/.git_sha"
  depends_on = [null_resource.clone]
}

resource "aws_s3_object" "release" {
  bucket = data.aws_s3_bucket.bucket.bucket
  key    = "${var.repo_name}.zip"
  source = data.archive_file.release_files.output_path
  depends_on = [
    data.archive_file.release_files
  ]
}
