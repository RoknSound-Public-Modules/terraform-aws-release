output "zipball_url" {
  value = github_release.release.zipball_url
}

output "entries" {
  value = data.github_tree.tree.entries
}