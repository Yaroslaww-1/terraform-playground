output "url" {
  value = module.producer.url
}

output "bucket" {
  value = module.s3.data_bucket_name
}
