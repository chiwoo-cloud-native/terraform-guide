resource "aws_vpc" "my" {
  cidr_block = "172.76.0.0/16"

  tags = {
    Name = "symple-dev-vpc"
  }
}
# 2Jqu1uP0oIU6M/FRZQXOCQcwyczBuLd/D2CT4vpezC0=
