resource "aws_docdb_cluster" "docdb" {
  cluster_identifier       = "roboshop-${var.ENV}-docdb"
  engine                   = "docdb"    // by default we will get this and its optional filed
  master_username          = local.DOCDB_USER
  master_password          = local.DOCDB_PASS      # these got from the local.tf and from the secret manager.
  skip_final_snapshot      = true  
  vpc_security_group_ids   = [aws_security_group.allows_docdb.id]
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnet_group.name  
}  




# creates subnet group 
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "roboshop-docdb-${var.ENV}-subnetgroup"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-docdb-${var.ENV}-subnetgroup"
  }
}

# Creates Compute instances needed for DocumentDB and these has to be attached to the cluster which we havew creared above
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.DOCDB_INSTANCE_COUNT
  identifier         = "roboshop-${var.ENV}-docdb-instance"
  cluster_identifier = aws_docdb_cluster.docdb.id                      #This argument attaches the nodes created here to the docdb cluster.
  instance_class     = var.DOCDB_INSTANCE_TYPE
  
  depends_on = [aws_docdb_cluster.docdb]        # This is used as a condition that if the cluster creates then only it will creates the instances.
}

# add the secrets and trying to fetch for user name and password