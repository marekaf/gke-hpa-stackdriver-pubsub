# These are inputs we need to define, these two are fairly common (on basically every stack ever)
variable "region" {
  default = "europe-west3"
} # The gcp region we want to be working with

data "google_compute_zones" "available" {}

variable "zone" {
  default = ""
} # The gcp region we want to be working with

variable "env" {
  default = "test"
} # This is a "prefix" which we will add to the name of everything tag to everything

variable "project" {
  default = "mab-testing" # The name of this project, often used in naming of resources created also
}

variable "cloudflare_email" {
  default = ""
}

variable "cloudflare_token" {
  default = ""
}

variable "project_slug" {}

variable "cluster_name" {
  default = "testing"
}

variable "oauth_scopes" {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

# These are things we'll use in various places
locals {
  credentials = "${file("./creds/serviceaccount.json")}"

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
    Project     = "${var.project}"
  }

  # take either var.zone or {var.region}-a zone
  zone = "${coalesce(var.zone,data.google_compute_zones.available.names[0])}"

  # set name_prefix
  default_name_prefix = "${substr(var.project,0,5)}"
  name_prefix         = "${var.project_slug != "" ? var.project_slug : local.default_name_prefix}"
}
