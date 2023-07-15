resource "aws_sqs_queue" "this" {
  name = "my-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn
    maxReceiveCount     = 2
  })
}

resource "aws_sqs_queue" "dead_letter" {
    name = "my-queue-dead-letter"
}