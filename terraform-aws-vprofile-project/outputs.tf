output "RDS_ENDPOINT" {
  value = aws_db_instance.vprofile_db_instance.endpoint
}

output "RMQ_ENDPOINT" {
  value = aws_mq_broker.vprofile_rabbitmq_broker.instances.0.endpoints
}

output "CACHE_ENDPOINT" {
  value = aws_elasticache_cluster.vprofile_cache.configuration_endpoint
}
#output "CLB_ENDPOINT" {
#  value = aws_elb.vprofile_elb.dns_name