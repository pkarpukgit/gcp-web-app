terraform {
  backend "gcs" {
    bucket  = "webapp-test-tfstate"
    prefix  = "state/test"
  }
}
