resource "aws_docdb_cluster" "docdb" {
  cluster_identifier       = "roboshop-${var.ENV}-docdb"
  engine                   = "docdb"    // by default we will get this and its optional filed
  master_username          = "admin1"
  master_password          = "roboshop1"
  skip_final_snapshot      = true  
}  





/* //  vpc_security_group_ids   = [aws_security_group.allows_docdb.id]
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnet_group.name */