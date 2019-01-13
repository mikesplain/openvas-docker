workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for Docker"]
}

workflow "New workflow 1" {
  on = "push"
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
}
