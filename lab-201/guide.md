# Terraform Basic
Terraform 에서 권고하는 프로젝트 레이아웃은 [Standard Module Structure](https://www.terraform.io/language/modules/develop/structure) 을 참조 할 수 있지만 관리와 자동화 목적에 따라 구성을 조정 할 수 있습니다.    
특히 대규모의 리소스를 관리하기 위해선 Workspace 를 통해 프로비저닝 단위를 분할하여 관리 하며, 각 Workspace 의 의존성을 잘 설계에 반영하여야 합니다.  

아래 프로젝트 레이아웃 예시는 Lego 블럭을 쌓아 올리는 것처럼 클라우드 리소스를 Workspace 단위로 하나씩 stack 을 쌓는 구조 입니다.  
```
.
├── resources
│   ├── alb
│   │   ├── data.tf
│   │   ├── env
│   │   │   ├── dev.tfvars
│   │   │   └── prd.tfvars
│   │   ├── state
│   │   ├── iam-role.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── security-group.tf
│   │   ├── target-group.tf
│   │   └── variables.tf
│   ├── ecs
│   │   ├── data.tf
│   │   ├── env
│   │   │   ├── dev.tfvars
│   │   │   └── prd.tfvars
│   │   ├── state
│   │   ├── iam-role.tf
│   │   ├── outputs.tf
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── security-group.tf
│   │   └── variables.tf
│   ├── rds
│   │   ├── data.tf
│   │   ├── env
│   │   │   ├── dev.tfvars
│   │   │   └── prd.tfvars
│   │   ├── state
│   │   ├── iam-role.tf
│   │   ├── outputs.tf
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── security-group.tf
│   │   └── variables.tf
│   └── vpc
│       ├── data.tf
│       ├── env
│       │   ├── dev.tfvars
│       │   └── prd.tfvars
│       ├── state
│       ├── outputs.tf
│       ├── main.tf
│       ├── providers.tf
│       ├── security-group.tf
│       └── variables.tf
├── services
│   └── backend
│       ├── env
│       │   ├── dev.tfvars
│       │   └── prd.tfvars
│       ├── data.tf
│       ├── outputs.tf
│       ├── main.tf
│       ├── providers.tf
│       ├── security-group.tf
│       ├── target-group.tf
│       └── variables.tf
└── README.md
```

- AWS 리소스를 위한 resources 디렉토리와, 사용자 애플리케이션 서비스를 위한 services 로 구분이 됩니다. 
- AWS 리소스는 VPC > ALB > EC2 순서대로 구성이 가능하며, 참조를 통해 원하는 값을 참조할 수 있습니다.    
- 파일 이름을 통해 대상 리소스 또는 참조나 설정 환경을 예상 할 수 있습니다.  
- 각 Workspace 단위로 프로비저닝 및 state 상태 파일을 관리하므로 대규모의 리소스를 한번에 관리하는 부담에서 자유롭고 프로비저닝 시간도 예측 가능합니다.  

<br>

## Convention over Configuration(CoC)
프로젝트 레이아웃과 파일명을 보고 직관적으로 무엇을 위한 것인지 개발자가 쉽게 이해할 수 있도록 하는 암묵적인 규칙 입니다.  
때문에 개발자가 별도로 가이드 또는 설명하지 않더라도 이 규칙을 준수하기만 하면 큰 구조를 흐트러뜨리지 않고 일관적으로 유지/확장이 가능 합니다.  
CoC 가 가능하려면 프레임워크와 같이 이미 잘 구조화된 토대가 마련되어 있어야 합니다.  



