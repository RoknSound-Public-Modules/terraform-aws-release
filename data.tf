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

data "github_ref" "ref" {
  owner      = var.repo_owner
  repository = var.repo_name
  ref        = "heads/${data.github_branch.branch.branch}"
}

data "github_tree" "tree" {
  recursive  = false
  repository = data.github_repository.repo.name
  tree_sha   = data.github_branch.branch.sha
}

data "github_repository_file" "file" {
  for_each   = toset([for entry in data.github_tree.tree.entries : entry.path])
  repository = data.github_repository.repo.name
  file       = each.value
}

# Archive multiple files and exclude file.
data "archive_file" "release_files" {
  type        = "zip"
  output_path = "${path.module}/${var.repo_name}.${var.tag_name}.zip"

  dynamic "source" {
    for_each = toset([for entry in data.github_tree.tree.entries : entry.path])
    content {
      content  = data.github_repository_file.file[source.key].content
      filename = source.key
    }
  }

  source {
    content  = data.github_branch.branch.sha
    filename = ".git_sha"
  }
}
