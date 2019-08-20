workflow "Publish" {
  on = "push"
  resolves = "publish"
}

action "publish" {
  needs = "run"
  uses = "peaceiris/actions-gh-pages@v1.0.1"
  env = {
    PUBLISH_DIR  = "build"
    PUBLISH_BRANCH = "gh-pages"
  }
  secrets = ["ACTIONS_DEPLOY_KEY"]
}

action "run" {
  uses = "./run/"
}
