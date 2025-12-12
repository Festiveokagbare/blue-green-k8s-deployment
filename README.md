# AWS EKS Blue-Green Deployment (Terraform + Kubernetes + GitHub Actions)

![blue-green deployment diagram](./diagram.png)

**blue-green-k8s-deployment** is a professional, production-ready implementation of a Blue-Green Deployment strategy using:

✅ **Terraform** (Infrastructure as Code)
✅ **AWS EKS** (Elastic Kubernetes Service)
✅ **Docker & AWS ECR** (Container Images)
✅ **Kubernetes Deployments & Services**
✅ **GitHub Actions CI/CD Pipeline**
✅ **Zero-downtime deploys & instant rollback**

This repository demonstrates how companies modernize and automate application delivery with minimal downtime and high availability.

---

## 🚀 What Is Blue-Green Deployment?

Blue-Green Deployment is a release strategy where two identical environments are created:

| Environment | Purpose |
|-------------|----------|
| **BLUE** | Current live version |
| **GREEN** | New version being tested before going live |

Traffic is switched atomically between BLUE and GREEN using Kubernetes Service selectors. This allows:

✔ Zero downtime production releases
✔ Instant rollback on failure
✔ Safe staged testing in real environment
✔ High reliability and user experience continuity :contentReference[oaicite:0]{index=0}

---

## 📦 Project Repository Structure

```bash
blue-green-k8s-deployment/
│
├── app/
│   ├── blue/                # v1 of the application (HTML page)
│   │   ├── Dockerfile
│   │   ├── app.py
│   │   ├── requirements.txt
│   │   └── templates/
│   │       └── index.html
│   │
│   └── green/               # v2 of the application (HTML page)
│       ├── Dockerfile
│       ├── app.py
│       ├── requirements.txt
│       └── templates/
│           └── index.html
│
├── k8s/
│   ├── deployments/
│   │   ├── blue-deployment.yaml
│   │   └── green-deployment.yaml
│   │
│   ├── service/
│   │   └── app-service.yaml
│   │
│   ├── ingress/
│   │   └── ingress.yaml
│   │
│   └── configmap-secret/
│       ├── configmap.yaml
│       └── secret.yaml
│
├── infra/
│   ├── main.tf              # root usage of modules
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       └── eks/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
├── .github/
│   └── workflows/
│       └── ci-cd.yaml
│
├── README.md
└── diagram.png
```


---

## 🏗 Infrastructure Provisioning (Terraform)

This repository uses Terraform to provision the AWS stack:

### 🔹 Provisioned Resources
- **VPC with private/public subnets**
- **Internet Gateway & NAT Gateways**
- **EKS Cluster + Managed Node Groups**
- **IAM Roles for EKS**
- **Security Groups**
- **Outputs (for kubectl configuration)**

💡 Terraform modules are organized for reusability under:

infra/modules/vpc
infra/modules/eks


### 🧠 Usage

```bash
cd infra
terraform init
terraform plan
terraform apply
```

After provisioning:

aws eks update-kubeconfig \
  --name bg-eks \
  --region $AWS_REGION


This configures kubectl with correct credentials.

🐳 App Code (Blue & Green)

Each version contains:

1. Dockerfile
2. app.py (Python Flask app)
3. requirements.txt
4. templates/index.html

They are separate Docker contexts:

app/blue
app/green

GitHub Actions builds and pushes both to ECR.

🧱 Kubernetes Deployment Manifests
🔹 Blue Deployment

k8s/deployments/blue-deployment.yaml defines:
* Deployment replica count
* Labels: app=blue-green-app, version=blue
* Container image reference (injected via CI/CD)

🔹 Green Deployment
Similar to blue, but with version=green.

🔹 Service

k8s/service/app-service.yaml defines a LoadBalancer that initially targets BLUE:

selector:
  app: blue-green-app
  version: blue


Switching traffic is done by updating this selector.

🔄 CI/CD Workflow (GitHub Actions)

This repository includes a professional GitHub Actions pipeline ci-cd.yaml which performs:

🧰 Build & Scan
Steps:

✔ Checkout source
✔ Set up Python
✔ Install dependencies for static analysis
✔ Bandit scan for security issues
✔ Set up QEMU & Docker Buildx
✔ Login to AWS ECR
✔ Build & push blue image
✔ Build & push green image
✔ Run Trivy security scan on both images

This ensures both images are scanned for vulnerabilities (CRITICAL/HIGH) before deployment.

🚀 Deploy & Release

Triggered on pushes to main or release/*.
Workflow Highlights
Configure AWS Credentials
Install tools (kubectl, aws cli, aws-iam-authenticator)
Generate kubeconfig for EKS
Verify cluster connectivity
Prepare namespace (blue-green-app)
Check existing deployments & service
Deploy/Update BLUE
Deploy GREEN
Rollout status checks
Smoketest GREEN
Patch Service selector (switch to GREEN)
Verify GREEN service
Scale down BLUE
Deployment summary
Auto-rollback if anything fails
Final verification

These steps ensure a fully automated Blue-Green deployment pipeline.

📌 Security & Best Practices
✔ No Long-Lived AWS Keys
Configured via GitHub Secrets

✔ Least Privilege IAM
EKS node roles and GitHub Actions roles are restricted

✔ CI/CD Image Scanning
Using Bandit & Trivy to enforce security

✔ Auto-Rollback on failure
Prevents failed releases from staying live

✔ Smoke Tests
Verifying app health before traffic switch

✔ Namespace Isolation
Dedicated namespace: blue-green-app

🧪 Running Blue-Green Switch

After successful rollout of GREEN:

kubectl patch service app-service -n blue-green-app \
  -p '{"spec":{"selector":{"app":"blue-green-app","version":"green"}}}'


To rollback or switch back to BLUE:

kubectl patch service app-service -n blue-green-app \
  -p '{"spec":{"selector":{"app":"blue-green-app","version":"blue"}}}'


Service selector switch ensures zero downtime.

🧠 Architecture Explained

Your cluster has:

Ingress Controller → Service (app-service) → Blue or Green Pods


The LoadBalancer (AWS ELB) sits at the edge and forwards traffic to Kubernetes service.
Pods version is selected using labels, animated at runtime by CI/CD.

This pattern is used by enterprises for safe deployments with rollback strategy.
GitHub

📈 Why This Matters

Blue-Green deployments are a standard production pattern used by tech companies to:

✔ Prevent downtime
✔ Allow instant rollback
✔ Run real network tests on new releases
✔ Decouple deployment from traffic switching

This strategy is widely used by organizations that value reliability and security in deployment workflows.
triedandtestedbuilds.com

📌 How to Test

Deploy with GitHub Actions

Wait for GREEN rollout

Browse ELB endpoint

Confirm responses from GREEN

Switch traffic via service selector

Validate final version

🛠 Future Improvements

✔ Canary deployments
✔ Helm Charts
✔ Monitoring (Prometheus, Grafana)
✔ Service mesh (Istio / App Mesh)
✔ Auto-rollback alerts
✔ Slack / Teams notifications

📚 Learning Resources

Blue-Green Deployment concept — Martin Fowler

Kubernetes Services & Selectors

AWS EKS best practices

✍️ License
MIT License — free to use and extend

👨‍💻 Author
Festive Okagbare — Cloud & DevOps Engineer