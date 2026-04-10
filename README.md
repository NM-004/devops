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

## Phase 3: Infrastructure as Code (Terraform + Azure)

Terraform creates:
- Azure Resource Group
- Virtual Network + Subnet
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- AKS permission to pull images from ACR (`AcrPull` role)

### Terraform setup
```bash
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply -auto-approve
```

## Phase 4: Container Registry (ACR)

After Terraform apply:
```bash
az acr login --name <acr-name>
```

Build and push images manually:
```bash
ACR_LOGIN_SERVER=$(az acr show --name <acr-name> --resource-group <rg-name> --query loginServer -o tsv)
docker build -t $ACR_LOGIN_SERVER/order-service:latest ./services/order-service
docker build -t $ACR_LOGIN_SERVER/restaurant-service:latest ./services/restaurant-service
docker build -t $ACR_LOGIN_SERVER/delivery-service:latest ./services/delivery-service

docker push $ACR_LOGIN_SERVER/order-service:latest
docker push $ACR_LOGIN_SERVER/restaurant-service:latest
docker push $ACR_LOGIN_SERVER/delivery-service:latest
```

## Phase 5: Kubernetes Deployment (AKS)

Manifests:
- `k8s/base/deployment.yaml`
- `k8s/base/service.yaml`
- `k8s/base/namespace.yaml`

Render manifests with your ACR login server:
```bash
chmod +x scripts/render-k8s-manifests.sh
./scripts/render-k8s-manifests.sh <acr-login-server>
```

Deploy:
```bash
az aks get-credentials --resource-group <rg-name> --name <aks-name> --overwrite-existing
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
2. Terraform job provisions/updates Azure infra on `main`.
3. CD job builds images, pushes to ACR, updates AKS deployments.

### Required GitHub configuration

Set repository secret:
- `AZURE_CREDENTIALS` (service principal JSON for `azure/login`)

Set repository variables:
- `RESOURCE_GROUP_NAME`
- `AZURE_LOCATION`
- `ACR_NAME`
- `AKS_CLUSTER_NAME`

Example `AZURE_CREDENTIALS` JSON format:
```json
{
  "clientId": "<app-id>",
  "clientSecret": "<password>",
  "subscriptionId": "<subscription-id>",
  "tenantId": "<tenant-id>"
}
```

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

- Kubernetes deployment manifests use `REPLACE_ACR_LOGIN_SERVER` placeholder and are rendered into `k8s/generated/` before deployment.
- This starter is for learning and project demonstration. For production, add image vulnerability scanning, policy checks, approvals, remote Terraform state, and advanced observability.
