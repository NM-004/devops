output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "ecr_registry_url" {
  description = "Base ECR registry URL"
  value       = split("/", values(aws_ecr_repository.services)[0].repository_url)[0]
}

output "ecr_repositories" {
  description = "ECR repository URLs"
  value = {
    for name, repo in aws_ecr_repository.services : name => repo.repository_url
  }
}

output "eks_kube_config_command" {
  description = "Command to fetch kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}
