variable "name" {
  description = "OOO 리소스 이름 입니다"
  type        = string
}

variable "tags" {
  description = "태그 속성 입니다."
  type        = map(string)
  default     = {
    Team      = "BTC"
    CreatedBy = "Terraform"
  }
}

variable "security_group_ids" {
  description = "OOO 리소스가 참조하는 보안 그룹 목록 입니다."
  type        = list(string)
}

variable "enable_dns_support" {
  description = "VPC 구성시 DNS 서비스를 활성화 할지 여부 입니다."
  type        = bool
  default     = true
}

variable "bastion_instance_type" {
  description = "Bastion EC2 인스턴스 타입 입니다."
  type        = string

  validation {
    condition = contains([
      "t2.micro", "t2.small", "t2.medium",
      "t3.micro", "t3.small", "t3.medium"
    ], var.bastion_instance_type)
    error_message = <<-EOF
      Please specify an approved instance_type only:
        "t2.micro", "t2.small", "t2.medium",
        "t3.micro", "t3.small", "t3.medium"
EOF
  }
}
