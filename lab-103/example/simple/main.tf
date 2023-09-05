resource "aws_vpc" "my" {
  cidr_block = "172.76.0.0/16"

  tags = {
    Name = "symple-dev-vpc"
  }
}
