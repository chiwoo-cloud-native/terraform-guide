# Terraform 기초

Terraform 아키텍처를 통해 동작 방식을 살펴보고 Provider, Resource, Variable, Output, Datasource 과 같은 Terraform 의 기본적인 요소를 이해합니다.

Terraform 이 인식하는 확장자는 HCL(Hashicorp Configuration Language) 언어로 작성된 *.tf 파일 입니다.

Terraform 은 파일 이름에 상관없이 디렉토리내의 모든 .tf 파일을 프로비저닝 리소스를 정의하고 있다고 간주 합니다.  
또한 *.tfvars 파일은 테라폼 변수를 정의합니다.

<br>

## Architecture

![](../images/img_12.png)

<br>

## Workflow

![](../images/img_17.png)

- write: Terraform Code 파일은 tf 확장자를 사용하며, 생성할 리소스들에 대한 tf 파일을 작성합니다.    

- init: Terraform 프로바이더 및 모듈과 같은 프로비저닝 환경이 포함된 프로젝트(작업 디렉토리)를 초기화하는 데 사용됩니다.      
        새로운 Terraform 구성을 작성했거나 버전이 변경된 경우에 실행해야 합니다.  
  
- plan: tf 파일의 내용을 반영할 경우 변경되는 점을 시각적으로 보여주고 적용이 가능한지 확인하는 과정입니다.    
    
- apply: tf 파일의 내용을 실제 REAL 반영하는 작업입니다.    
  
- destroy: tf 파일의 내용을 기준으로 정의된 리소스를 REAL 인프라에서 삭제하는 작업입니다.    


<br>

## Provider

AWS, GCP, AZure 와 같은 클라우드 환경에 리소스 및 서비스를 생성할 수 있도록 각각의 벤더가 제공하는 Open-API 를 통해 액세스하는 주체가 Provider 입니다.

[Provider](https://registry.terraform.io/browse/providers) 는 CSP 및 오픈소스에서 제공 되고 있으며 다음은 Provider 를 정의 하는 예시 입니다.

- AWS 클라우드를 액세스 하기위한 프로바이더 선언 예시

```hcl
provider "aws" {
  profile = "<MY-AWS-PROFILE>"
  region  = "ap-northeast-2"
}
```

- GCP 클라우드를 액세스 하기위한 프로바이더 선언 예시

```hcl
provider "google" {
  project = "<MY-PROJECT-ID>"
  region  = "us-central1"
}
```

- AWS 및 GCP 를 모두 액세스 하는 멀티클라우드 프로비저닝을 위한 프로바이더 선언 예시

```hcl
terraform {
  required_version = ">= 1.4.0, < 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
    google = {
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  profile                  = "<MY-AWS-PROFILE>"
  shared_config_files      = ["<YOUR-AWS-CONFIG-DIR>/config"]
  shared_credentials_files = ["<YOUR-AWS-CONFIG-DIR>/credentials"]
  region                   = "ap-northeast-2"
}

provider "google" {
  credentials = "<YOUR-GCP-CREDENTIALS-DIR>/credentials.json"
  project     = "<MY-PROJECT-ID>"
  region      = "us-central1"
  zone        = "us-central1-c"
}
```

### 프로바이더 참조 
- [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GCP](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [confluent](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)
- [datadog](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)
- [datadog](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)
- [elasticstack](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs)

<br>

## Resource
테라폼 핵심 개체로 REAL 인프라에 구성 할 대상을 코드로 정의 하며 REAL 인프라에서 실제 인스턴스를 생성 / 수정 / 삭제 등과 같은 자동화된 관리를 할 수 있습니다.    
또한, AWS, AZure, GCP, Kubernetes 등 프로바이더로부터 `resource` 예약어를 통해 다양한 유형의 리소스를 정의 합니다.    

아래와 같이 aws_instance 리소스 타입은 Amazon EC2 가상 머신을 resource 예약어로 선언하고 테라폼을 통해 프로비저닝 할 수 있습니다.

```hcl
resource "aws_instance" "bastion" {
  ami                     = "ami-a1b2c3d4"
  instance_type           = "t3.medium"
  #
  availability_zone       = "us-east-2a"
  subnet_id               = "subnet-0aec2cefacf48157a"
  vpc_security_group_ids  = ["sg-0949965f1a940621d"]
  ebs_optimized           = false
  disable_api_termination = true
  #
  key_name                = "my-bastion-keypair"
}
```

<br>

- 리소스 구조 확인 

![](../images/img_6.png)


<br>

## Variable

리소스가 참조하는 변수로 `var.` 참조자를 통해 값을 참조 할 수 있습니다.  

![](../images/img_8.png)

<br>

### 변수 정의

- Terraform 변수를 정의 합니다.

```
# string 타입
variable "name" {
  description = "리소스 이름 입니다."
  type        = string 
}

# number 타입 
variable "listen_port" {
  description = "애플리케이션 서비스 포트 입니다."
  type        = number
}

# Boolean 타입 
variable "enabled_ipv6" {
  description = "IPv6 주소 체계를 활성화 합니다."
  type        = bool
  default     = false
}

# List 컬렉션
variable "subnet_ids" {
  type        = list(string)  
}

# Map 컬렉션
variable "tags" {
  type        = map(string) 
  default     = {
    Project = "apple"
    Team = "BTC"
  }
}

```

<br>

### 변수 입력 방식

1. terraform apply 를 통한 콘솔에서의 입력

![](../images/img_9.png)

2. **terraform.tfvars** 예약된 변수 파일 정의

```hcl
name      = "my-bastion"
task_port = 8080
```

3. 사용자 정의 변수 파일 정의 (예: dev.tfvars, prd.tfvars, snowflake.tfvars)
   참조 변수를 환경별, 대상 서비스별로 구분하면 동일한 stack 을 원하는 대상에 동일하게 프로비저닝 할 수 있습니다.

**`dev.tfvars`**

```hcl
name         = "my-bastion"
listen_port  = 80
enabled_ipv6 = false
subnet_ids   = ["sn-aslkf23123"]
tags         = {
  Team      = "BTC"
  CreatedBy = "Terraform"
}
```

사용자 정의 변수 파일은 terraform apply 명령에서 -var-file 옵션을 통해 적용이 가능 합니다.

```
terraform plan -var-file=./dev.tfvars
```

4. `-var` 옵션을 통해 콘솔 명령에서 직접 입력
```
terraform plan -var foo="bar" -var fruit="apple" 
```

5. `Tf_VAR_` 환경 변수를 통한 입력
```
export TF_VAR_foo="bar"
export TF_VAR_fruit="apple"

terraform plan 
```

<br>

### Local 변수 및 활용

locals 블럭으로 제한된 범위(Local Scope) 내에서만 `local.` 참조자를 통해 참조 할 수 있습니다.

자주 사용되는 참조 정보, 일관된 리소스의 명칭, 비교 조건, 복잡한 데이터 구조 정의 등을 위해 사용 됩니다.

```hcl
locals {
  # 자주 참조 되는 VPC_ID 
  vpc_id = "vpc-asf72983"

  # 리소스 이름 정의시 접두어를 정의함으로 일관된 네이밍을 정의 
  name_prefix = "${var.project}-${var.region}"

  # 인스턴스 타입이 t 유형인지 여부 - EC2 를 T 타입만 생성 또는 제외하고자 할 때 사용 
  t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false

  # 복잡한 데이터 구조 정의 
  tags = {
    Project   = "apple"
    Owner     = "devops@your.company"
    Team      = "BTC"
    CreatedBy = "Terraform"
  }
}

```

<br>

- 리소스 네이밍 규칙 적용 예시

![](../images/img_7.png)

<br>

## Outputs

프로비저닝 과정을 통해 코드로 정의한 리소스가 인스턴스로 생성되면 해당 인스턴스가 가지는 실제 속성 값들을 output 으로 보낼 수 있습니다.    
output 결과 값들은 프로비저닝 결과를 확인 하거나 프로비저닝 과정에서 이 값을 필요로 하는 리소스에 전달 할 수 있습니다.

**outputs.tf** 파일 정의 예시

```hcl
output "id" {
  description = "EC2 인스턴스 아이디 입니다."
  value       = aws_instance.ec2.id
}

output "arn" {
  description = "EC2 인스턴스 ARN 입니다."
  value       = aws_instance.ec2.arn
}

output "instance_state" {
  description = "EC2 인스턴스 상태 입니다. `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped` 의 값들 중 하나입니다."
  value       = aws_instance.ec2.instance_state
}

output "private_ip" {
  description = "EC2 인스턴스에 할당된 private_ip 입니다."
  value       = try(aws_instance.ec2.private_ip, "")
}

output "public_ip" {
  description = "EC2 인스턴스에 할당된 public_ip 입니다."
  value       = try(aws_instance.ec2.public_ip, "")
}

output "tags_all" {
  description = "EC2 인스턴스의 태그 및 속성 값들 입니다."
  value       = try(aws_instance.this.tags_all, {})
}

```

<br> 

### 사용 예시

- nginx 폴더의 nginx.tf

```hcl
resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.nginx.repository_url
}
```

- lambda 폴더의 lambda.tf

```hcl
module "nginx" {
  source = "../nginx/"
}

resource "aws_lambda_function" "new" {
  function_name = "my-basic-lambda"
  image_uri     = module.nginx.ecr_repository_url # output 값을 참조
  package_type  = "Image"
  memory_size   = 1024
  vpc_config {
    subnet_ids         = ["subnet-0361b47d738fdec9a"]
    security_group_ids = ["sg-032ebbae551a82e9c"]
  }
}
```

<br>


## Datasource

Datasource 는 이미 존재하는 인스턴스 참조를 위해 사용 합니다.  
`data` 예약어로 정의 하며 인스턴스 변경이 불가능한 immutable 특징을 가집니다.

```hcl
# tagging 속성 중 Name 속성 값이 "default-vpc" 인 것을 참조합니다.  
data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"]
  }
}

# default-vpc 에 구성된 subnet 중 리소스 이름이 "default-pub-az1-sn" 인 서브넷을 참조합니다.   
data "aws_subnets" "pub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "tag:Name"
    values = ["default-public-az1-sn"]
  }
}


locals {
  # VPC 데이터 소스 참조 예시 
  default_vpc_id         = data.aws_vpc.default.id # 데이터 소스로부터 VPC ID 를 참조 
  default_vpc_cidr_block = data.aws_vpc.this.cidr_block # 데이터 소스로부터 VPC 의 CIDR 블럭 값을 참조
  # Public Subnet 데이터 소스 참조 예시 
  public_subnet_ids      = toset(data.aws_subnets.pub.ids)
}
```

