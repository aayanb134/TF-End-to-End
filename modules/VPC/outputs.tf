output "vpc-id" {
  value = aws_vpc.main.id
}

output "public-subnet-ids" {
  value = aws_subnet.public-subnet[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.private-subnet[*].id
}

output "nat-gateway-id" {
  value = aws_nat_gateway.public[*].id
}

output "public-route-table-id" {
  value = aws_route_table.public-route-table.id
}

output "private-route-table-id" {
  value = aws_route_table.private-route-table[*].id
}

output "internet-gateway-id" {
  value = aws_internet_gateway.main-igw.id
}
