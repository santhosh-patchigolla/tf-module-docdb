resource "aws_docdb_cluster" "docdb" {
  cluster_identifier       = "roboshop-${var.ENV}-docdb"
  engine                   = "docdb"    // by default we will get this and its optional filed
  master_username          = "admin1"
  master_password          = "roboshop1"
  skip_final_snapshot      = true  
  vpc_security_group_ids   = [aws_security_group.allows_docdb.id]
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnet_group.name  
}  





# Creating the subnet groupID from below
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "roboshop-docdb-${var.ENV}-subnetgroup"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-docdb-${var.ENV}-subnetgroup"
  }
}

# Creates Compute Machines needed for DocumentDB and these has to be attached to the cluster
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "roboshop-${var.ENV}-docdb-instance"
  cluster_identifier = aws_docdb_cluster.docdb.id                      #This argument attaches the nodes created here to the docdb cluster.
  instance_class     = "db.t3.medium"

  depends_on = [aws_docdb_cluster.docdb]
}