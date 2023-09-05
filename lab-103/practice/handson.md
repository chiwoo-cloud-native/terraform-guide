## Q1. terraform destroy 를 한 뒤에 다시 terraform apply 명령을 실행하면 어떤 일이 벌어지나요?

<br>

## Q2. terraform apply 를 한 뒤에 terraform.tfstate 파일을 삭제 하고 terraform apply 명령을 실행하면 어떤일이 벌어지나요?

<br>

## Q3. terraform apply 진행중에 다른 사람이 terraform apply 명령을 실행하면 어떤 일이 벌어지나요?

<br>

## Q4. 팀에서 다른 동료와 같이 테라폼 코드를 통해 REAL 인프라를 공동으로 관리 한다면 어떻게 해야 하나요?

<br>

## Q5. terraform 명령을 통해 plan, apply, destroy 를 확인 하세요.

- terraform 코드를 작성 하세요.
- AWS 프로바이더에서 제공하는 리소스로 유형은 제한이 없습니다.
- terraform plan, apply, destroy 를 확인 하세요.

<br>

## Q6. terraform 상태 파일 Quiz

aws_vpc 리소스를 정의하는 terraform 코드를 아래와 같이 작성 하였습니다.

```hcl
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}
```

`terraform apply` 명령을 실행 한다고 가정하면 어떤 Operation 이 적용 될까요?

- create - REAL 클라우드 인스턴스를 생성 합니다.
- delete - REAL 클라우드 인스턴스를 삭제 합니다.
- update state - terraform 상태파일을 갱신 합니다.
- N/A - 아무런 동작도 하지 않습니다.

| write code (*.tf) | tfstate | REAL Cloud Instance | Operation | 
|:-----------------:|:-------:|:-------------------:|:---------:|
|      aws_vpc      |    -    |          -          |  Answer1  |
|      aws_vpc      | aws_vpc |          -          |  Answer2  |
|      aws_vpc      | aws_vpc |       aws_vpc       |  Answer3  |
|         -         | aws_vpc |       aws_vpc       |  Answer4  |
|         -         |    -    |       aws_vpc       |  Answer5  |
|         -         | aws_vpc |                     |  Answer6  |
 
