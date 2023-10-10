variable "arm_subscription_id" {
  type    = string
}
variable "arm_tenant_id" {
  type    = string
}
variable "arm_client_id" {
  type    = string
}
variable "arm_client_secret" {
  sensitive = true
  type      = string
}
variable "image_name" {
  type = string
}
variable "image_version" {
  type = string
}
variable "agent_ipaddress" {
  type = string
}