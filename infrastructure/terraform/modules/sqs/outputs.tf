output "queue_url" {
  description = "URL da fila SQS"
  value = aws_sqs_queue.main.url
}

output "queue_arn" {
  description = "ARN da fila SQS"
  value = aws_sqs_queue.main.arn
}

output "queue_name" {
  description = "Nome da fila SQS"
  value = aws_sqs_queue.main.name
}

output "dlq_url" {
  description = "URL da Dead Letter Queue"
  value = aws_sqs_queue.dlq.url
}

output "dlq_arn" {
  description = "ARN da Dead Letter Queue"
  value = aws_sqs_queue.dlq.arn
}