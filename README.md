# 🚀 Cost‑Optimized Infrastructure as Code (IaC)

## 📌 Overview
This project demonstrates a **multi‑cloud, production‑grade DevOps setup** using **Terraform, Jenkins, AWS, GCP, CloudWatch, Prometheus, and Grafana**.  
It focuses on **cost optimization, elasticity, and security automation**, reducing monthly cloud spend by ~25% while ensuring high availability and compliance.

---

## 🎯 Key Features
- **Infrastructure as Code (IaC)** → Modular Terraform for AWS & GCP (VPC, Subnets, ALB, ASG, IAM, Storage).
- **Cost Optimization** → Infracost integration + automated right‑sizing + cleanup policies.
- **Elasticity** → Auto Scaling Group (ASG) with CloudWatch alarms (CPU‑based scale in/out).
- **CI/CD** → Jenkins pipeline with Terraform, Infracost, compliance checks, and automated validation.
- **Monitoring & Observability** → Prometheus + Grafana dashboards (CPU, ALB requests, ASG scaling).
- **Security** → IAM least‑privilege policies + secrets management (AWS Secrets Manager / GCP Secret Manager).
- **Demo‑Ready** → Load testing (Apache Benchmark) to trigger scaling events, visualized in Grafana.

---

## 🏗️ Architecture

flowchart TD
    A[Users] -->|HTTP Requests| B[ALB - Public Subnet]
    B --> C[Auto Scaling Group - Private Subnet]
    C --> D[EC2 App Instances]
    C --> E[(NAT Gateway)]
    E --> F[Internet]
    D --> G[(Secrets Manager)]
    D --> H[(CloudWatch Metrics)]
    H --> I[Prometheus Exporter]
    I --> J[Grafana Dashboard]
    J --> K[Developers/Stakeholders]

⚙️ Tech Stack
IaC: Terraform (modular, reusable)

CI/CD: Jenkins, GitHub Actions

Cloud: AWS (EC2, ALB, ASG, VPC, IAM, CloudWatch), GCP (GCE, IAM, Monitoring)

Monitoring: Prometheus, Grafana, CloudWatch

FinOps: Infracost

Security: IAM automation, Secrets Manager

Testing: Apache Benchmark (ab)

🚦 CI/CD Pipeline Flow
Checkout → Pull Terraform code from GitHub.

Terraform Init & Validate → Ensure syntax & providers are correct.

Infracost → Show cost diff before deployment.

Policy Check → OPA/Conftest compliance validation.

Terraform Plan & Apply → Deploy infra.

Validation → Confirm CloudWatch alarms & ASG policies.

Load Test → Apache Benchmark triggers scaling.

Monitoring → Grafana dashboard shows scaling in real time.

---

📊 Demo Flow
Deploy infra via Jenkins pipeline.

Run load test: ./scripts/load_test.sh <ALB_DNS>

Watch Grafana dashboard:

CPU spikes above 70% → ASG scales out.

Requests drop → ASG scales back in.

📂 Repository Structure

terraform-project/
├── modules/
│   ├── vpc/
│   ├── compute/
│   ├── iam/
│   └── storage/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── scripts/
│   └── load_test.sh
├── Jenkinsfile
└── README.md

---

🗣️ Interview Story (STAR)
Situation: Cloud costs were rising due to overprovisioned resources and inconsistent IAM policies.

Task: Build a repeatable, compliant IaC framework that reduces costs and improves security.

Action: Designed Terraform modules for AWS & GCP, integrated Infracost, automated IAM + secrets, and validated scaling with load tests + Grafana dashboards.

Result: Achieved 25% monthly cost reduction, improved compliance posture, and delivered a reusable IaC framework for multi‑cloud deployments.

---

🚀 Next Steps
Extend to Azure for full tri‑cloud coverage.

Add cost dashboards in Grafana (FinOps visibility).

Integrate security scanning (Snyk, Trivy) into CI/CD.



Mermaid Diagram:
```
flowchart TD
    subgraph Public_Subnet["🌐 Public Subnet"]
        ALB[Application Load Balancer]
        NAT[NAT Gateway]
    end

    subgraph Private_Subnet["🔒 Private Subnet"]
        ASG[Auto Scaling Group]
        EC2[App Instances]
    end

    subgraph Monitoring["📊 Monitoring & FinOps"]
        CW[CloudWatch Alarms]
        Prom[Prometheus]
        Grafana[Grafana Dashboard]
        Infracost[Infracost (Cost Estimation)]
    end

    Users[👥 Users] -->|HTTP Requests| ALB
    ALB --> ASG
    ASG --> EC2
    EC2 --> NAT --> Internet[(🌍 Internet)]

    EC2 --> CW
    CW --> Prom
    Prom --> Grafana
    Infracost --> Jenkins[CI/CD Pipeline]

    subgraph CI_CD["⚙️ Jenkins Pipeline"]
        Jenkins --> Terraform[Terraform IaC]
        Terraform --> ALB
        Terraform --> ASG
        Terraform --> NAT
    end
```
