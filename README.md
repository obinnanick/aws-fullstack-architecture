# AWS Fullstack Architecture

## Overview
This project provisions a **complete AWS infrastructure** using **Terraform**, following best practices for scalability, security, and high availability. The architecture is designed to support a fullstack application with backend services, databases, and frontend hosting.

## Project Breakdown

### 1️⃣ **VPC (Virtual Private Cloud)**
A custom **VPC** is created to isolate resources and define networking rules. This VPC enables secure communication between different components.

### 2️⃣ **Subnets (Public & Private)**
- **Public Subnets**: These host resources that require internet access, such as an **Application Load Balancer (ALB)** or bastion hosts.
- **Private Subnets**: Used for resources that should not be exposed to the internet, like **databases and backend services**.

### 3️⃣ **Route Tables & Internet Gateway**
- **Public Route Table**: Routes traffic from public subnets to the **Internet Gateway (IGW)** for internet access.
- **Private Route Table**: Routes private subnet traffic through a **NAT Gateway** to access external resources securely.

### 4️⃣ **NAT Gateway & Elastic IP (EIP)**
- **NAT Gateway** allows instances in private subnets to connect to the internet (for updates, API calls, etc.) without being directly exposed.
- **Elastic IP** is attached to the NAT Gateway for a consistent external IP.

### 5️⃣ **Security Groups & IAM Roles**
- **Security Groups** define rules for inbound/outbound traffic to secure resources.
- **IAM Roles** provide fine-grained permissions for AWS services, ensuring least privilege access.

### 6️⃣ **Compute Layer (ECS Fargate / EC2 Instances) & Auto Scaling**
- The backend services will be deployed using **Amazon ECS Fargate**, allowing serverless containerized deployments.
- Auto Scaling is configured to automatically adjust the number of running containers based on demand.
- Alternatively, **EC2 instances** could be used, depending on workload requirements.

### 7️⃣ **Database Layer (RDS/Aurora)**
- A **managed database service (RDS)** is provisioned within the private subnet for security.
- This ensures high availability, scalability, and automated backups.

### 8️⃣ **S3 & CloudFront for Frontend Hosting**
- The **frontend application** is hosted on **Amazon S3**, ensuring scalability and low cost.
- **CloudFront** is used for caching and serving static content efficiently to users worldwide.

### 9️⃣ **CI/CD with GitHub Actions**
- **GitHub Workflows** automate infrastructure and application deployments.
- Terraform state management and deployments will be handled via GitHub Actions.

### 🔟 **Security with AWS WAF & Shield Standard**
- **AWS WAF** protects the application from web attacks.
- **AWS Shield Standard** provides **DDoS protection** for AWS resources.

## Deployment Steps
1. **Clone the repository**:
   ```sh
   git clone <repo_url>
   cd aws-fullstack-architecture
   ```
2. **Initialize Terraform**:
   ```sh
   terraform init
   ```
3. **Preview the infrastructure changes**:
   ```sh
   terraform plan
   ```
4. **Apply the changes to deploy resources**:
   ```sh
   terraform apply -auto-approve
   ```
5. **Retrieve output values** (VPC ID, Subnet IDs, etc.):
   ```sh
   terraform output
   ```

## Outputs
- `vpc_id` - The ID of the created VPC.
- `public_subnet_ids` - List of public subnet IDs.
- `private_subnet_ids` - List of private subnet IDs.
- `nat_gateway_id` - The ID of the NAT Gateway.
- `alb_dns_name` - The DNS name of the Application Load Balancer.
- `rds_endpoint` - The endpoint for the database connection.

## Cleanup
To destroy the infrastructure when no longer needed:
```sh
terraform destroy -auto-approve
```

## Future Enhancements
- Implement **AWS Lambda** for event-driven serverless functions.
- Configure **CloudWatch monitoring and logging** for better observability.
- Enhance **IAM security policies** for least privilege access.

---
📌 **Maintainer**: Nick 🚀

fe