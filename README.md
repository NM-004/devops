# End-to-End DevOps Pipeline: Food Delivery Microservices

This project is a complete DevOps reference implementation for a food delivery microservices application.

## Phase 1: Source Code Management (Git & GitHub)

### Repository setup
1. Initialize git:
   ```bash
   git init
   ```
2. Add remote:
   ```bash
   git remote add origin <your-github-repo-url>
   ```
3. Commit and push:
   ```bash
   git add .
   git commit -m "Initial DevOps pipeline setup"
   git branch -M main
   git push -u origin main
   ```

## Phase 2: Containerization (Docker)

Each microservice contains a `Dockerfile`:
- `services/order-service/Dockerfile`
- `services/restaurant-service/Dockerfile`
- `services/delivery-service/Dockerfile`

### Local image creation
```bash
docker compose build
docker compose up -d
```

### Local health checks
```bash
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
```

## Phase 3: Infrastructure as Code (Terraform + AWS)

Terraform creates:
- AWS VPC + public subnets
- Internet Gateway + route table
- AWS EKS cluster + managed node group
- AWS ECR repositories for each microservice

### Terraform setup
```bash
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply -auto-approve
```

## Phase 4: Container Registry (ECR)

After Terraform apply:
```bash
aws ecr get-login-password --region <aws-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<aws-region>.amazonaws.com
```

Build and push images manually:
```bash
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY=$AWS_ACCOUNT_ID.dkr.ecr.<aws-region>.amazonaws.com
docker build -t $ECR_REGISTRY/order-service:latest ./services/order-service
docker build -t $ECR_REGISTRY/restaurant-service:latest ./services/restaurant-service
docker build -t $ECR_REGISTRY/delivery-service:latest ./services/delivery-service

docker push $ECR_REGISTRY/order-service:latest
docker push $ECR_REGISTRY/restaurant-service:latest
docker push $ECR_REGISTRY/delivery-service:latest
```

## Phase 5: Kubernetes Deployment (EKS)

Manifests:
- `k8s/base/deployment.yaml`
- `k8s/base/service.yaml`
- `k8s/base/namespace.yaml`

Render manifests with your container registry URL:
```bash
chmod +x scripts/render-k8s-manifests.sh
./scripts/render-k8s-manifests.sh <container-registry-url>
```

Deploy:
```bash
aws eks update-kubeconfig --region <aws-region> --name <eks-cluster-name>
kubectl apply -f k8s/generated/namespace.yaml
kubectl apply -f k8s/generated/deployment.yaml
kubectl apply -f k8s/generated/service.yaml
```

## Phase 6: Configuration Management (Ansible)

Ansible playbook:
- `ansible/deploy.yml`

Run:
```bash
cd ansible
cp inventory.ini.example inventory.ini
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventory.ini deploy.yml
```

## Phase 7: CI/CD Pipeline (GitHub Actions)

Workflow:
- `.github/workflows/ci-cd.yml`

Pipeline behavior:
1. CI job installs dependencies for each service.
2. Terraform job provisions/updates AWS infra on `main`.
3. CD job builds images, pushes to ECR, updates EKS deployments.

### Required GitHub configuration

Set repository secret:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Set repository variables:
- `AWS_REGION`
- `PROJECT_NAME`
- `ENVIRONMENT`
- `EKS_CLUSTER_NAME`

## Project Structure

```text
.
├── .github/workflows/ci-cd.yml
├── ansible/
├── infrastructure/terraform/
├── k8s/base/
├── scripts/
└── services/
```

## Notes

- Kubernetes deployment manifests use `REPLACE_CONTAINER_REGISTRY` placeholder and are rendered into `k8s/generated/` before deployment.
- This starter is for learning and project demonstration. For production, add image vulnerability scanning, policy checks, approvals, remote Terraform state, and advanced observability.
