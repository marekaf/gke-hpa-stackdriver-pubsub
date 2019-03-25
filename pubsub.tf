resource "google_pubsub_topic" "echo" {
  name = "echo"
}

resource "google_pubsub_subscription" "echo" {
  name  = "echo-read"
  topic = "${google_pubsub_topic.echo.name}"

  ack_deadline_seconds = 20
}
