# Connecting Azure to GitHub

This is a demonstration of how to manage and rotate Azure service principal secrets in GitHub.

See this blog entry for more details [https://foldr.uk/rotating-azure-credentials-in-github-with-terraform](https://foldr.uk/rotating-azure-credentials-in-github-with-terraform).

In this repo:

* bootstrap - this bootstraps a storage account for the terraform state
* rotate - the terraform that creates service principals, rotates their secrets and pushes them into GitHub
* simplerotate - a simple example of safely rotating secrets using terraform
