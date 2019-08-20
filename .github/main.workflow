workflow "Publish" {
  on = "push"
  resolves = "publish"
}

action "publish" {
  needs = "run"
  uses = "peaceiris/actions-gh-pages@v1.1.0"
  env = {
    PUBLISH_DIR  = "./build"
    PUBLISH_BRANCH = "gh-pages"
  }
  secrets = ["GITHUB_TOKEN"]
}

action "run" {
  uses = "./run/"
}
