---
name: cloud-infrastructure-as-code
description: Blueprint infrastruktur Terraform/OpenTofu modular (VPC, security groups, subnets, dan state locking via S3/DynamoDB).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Terraform, OpenTofu, IaC, Cloud, DevOps, Infrastructure]
---

# Modular Infrastructure as Code (IaC) with OpenTofu / Terraform (Ibra X 3.1)

Pedoman arsitektur penyediaan sumber daya cloud terdefinisi kode yang aman, idempoten, dan dapat direproduksi secara konsisten.

## 1. Remote State Backend dengan State Locking (`backend.tf`)

Mencegah modifikasi konkuren yang dapat merusak file status infrastruktur:

```hcl
terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "ibra-terraform-state-prod"
    key            = "core-infra/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "ibra-tf-state-locks"
    encrypt        = true
  }
}
```

## 2. Pola Penamaan Tag Standar & Resource Isolation
- Selalu berikan tag `Environment`, `Owner`, dan `ManagedBy = "Ibra-IaC"`.
- Gunakan variabel input yang tervalidasi dengan kondisi *type constraints*.
