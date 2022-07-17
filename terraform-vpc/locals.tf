locals {
  # The ID of the VPC you've created
  vpc_id = aws_vpc.vpc1.id

  # List of available private subnet ids within the VPC you've created.
  private_subnet_ids = [aws_subnet.private.id]

  # List of available public subnet ids within the VPC you've created.
  public_subnet_ids = [aws_subnet.public.id]
}