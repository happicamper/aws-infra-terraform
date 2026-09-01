<img width="1562" height="852" alt="aws_infra_archi" src="https://github.com/user-attachments/assets/86ae43df-4bf3-44af-ad1b-bbf0e8bdd8f8" />


# AWS Infrastructure

## Architecture

This infrastructure is an internet-facing web application equipped with Cloudfront for CDN and WAF for added security right before the traffic gets inside the VPC. Deployed an Application Load Balancer that points to the compute layer which consist of EC2 deployed by Autoscaling group for availability and scalability. 
To achieve high availability the resources are deployed on two Availability zones which have multiple public and private subnets.

**Traffic flow (inbound):**
1. Users traffic goes to **CloudFront** which has a **WAF (CLOUDFRONT-scoped) Web ACL** attached, preventing malicious requests by set of rule sets at the edge before they reach the origin. In this case the origin pointed to ALB.
2. CloudFront forwards requests to the **Application Load Balancer (ALB)** that listens to port 80(HTTP) which resides in **public subnets** across two AZs (`ap-southeast-1a`, `ap-southeast-1b`). The public subnets are are also protected by NACL.
3. The ALB listener rule forwards traffic to a **target group**, the registered targets are the instances managed by Auto scaling group. For enhanced security we placed our ASG inside the private subnets and also equipped by **security** group that only allows inbound from the ALB.

**Traffic flow (outbound):**
- Private subnet ASG instances route outbound internet traffic (installs, patches, external API calls) through a **NAT Gateway** inside a public subnet.

**Network layout:**
- 1 VPC, 2 AZs, 2 Public Subnets, 2 Private Subnets
- A **NACL** applies at the VPC level.
- A dedicated **security group** governs traffic to the ASG instances, allowing HTTP/HTTPS/Tomcat only from the ALB's security group.
- The ALB has its own security group allowing inbound HTTP/HTTPS from `0.0.0.0/0`.

**Terraform module structure:**

**root module → child module → registry module**

- The **root module** (each `environments/dev/*` directory) is where the terraform commands: `terraform init`/`plan`/`apply`' gets executed. It consists of per-environment configurations. We can pass specific values to be applied in the environment via `terraform.tfvars`.
- The **child modules** (`modules/*`) - wrapper modules. Each one calls a specific **official Terraform Registry module**. It can contain the consistent/standard configurations we want to apply across environments.
- The **registry modules** are the community-maintained modules doing the real resource creation. It gets pulled from the registry when executing `terraform init`.

**Root and Child module approach**
- **Version isolation** — when upgrading versions, all we need to configure is the child module instead of changing the code on each environment.
- **Simplified** — look at it as a simplified registry modules because of unused inputs got trimmed. Inputs are passwed through `terraform.tfvars`.
- **Reusability** — the same child module can be used by mutiple environments.  If we are trying to reproduce the same setup from environment/dev to environment/stage we can reuse the child module. We can differ the configuration by passing environment-specific values via `terraform.tfvars`.

**directory structure**
- **Logical resource group and separate statefiles** - Divided the infrastructure into mutiple segments(`network`, `compute`, `edge`) for ease of management as infrastructure grows. Managing a monolithic statefile can be problematic in the future these includes: 
1. Single point of failure/larger blast radius
2. Statefile locking among team members
3. Slower execution(reads entire infrastructure)

## How to run Terraform

Resources are split across three independently-applied stacks. **network → compute → edge**

### 1. Network/VPC Stack

```bash
cd environments/dev/network
terraform init
terraform plan
terraform apply
```

### 2. Compute stack

```bash
cd environments/dev/compute
terraform init
terraform plan
terraform apply
```
### 2. Edge stack

```bash
cd environments/dev/edge
terraform init
terraform plan
terraform apply
```

### Variables

Update `terraform.tfvars` in each directory before applying — notably `vpc_id`, `vpc_name`, subnet CIDRs, `ami_id`, and the S3 backend bucket/key in each stack's backend configuration.

### Destroying

Reverse the order — **edge → compute → network**

```bash
cd environments/dev/edge && terraform destroy
cd environments/dev/compute && terraform destroy
cd environments/dev/network && terraform destroy
```

## Required Credentials
Utilizing OIDC instead of AWS Access Keys and Secrets for better security  
AWS_ROLE_ARN - The role that github runners will use when performing the CICD

## Assumptions made

- This is a **dev environment** — sized and configured for testing, not production traffic.
- The VPC and its public/private subnets already exist and are looked up via data sources, not created by this project.
- CloudFront uses the **default `*.cloudfront.net` domain** — no custom domain or ACM certificate is configured.
- A **single NAT Gateway** is used (not one per AZ), to minimize cost in this dev environment.
- WAF uses only the **AWS Managed Common Rule Set** — no rate limiting, geo-blocking, or bot control, to keep costs minimal while still demonstrating WAF functionality.
- CloudFront caching is set to **CachingDisabled**, since the origin serves dynamic application traffic, not static content.

## Known limitations

- **Limit to two EC2 for ASG** - due to budget cost we are only able to provide maximum of 2 EC2 during peak traffic.
- **No Route 53** — only the standard cloudfront provided domain `*.cloudfront.net`
- **Multi-part terraform apply** - need to execute apply on each logical group within the environment
- **Single NAT Gateway** - outbound from the private subnets will be impacted if the AZ where the NAT GW lives went down. 
- **No WAF rate limiting or bot protection** - current rule set — only baseline OWASP protection via the Common Rule Set.
- **WAF Regional not compatible with Cloudfront** - Since Cloudfront is a global resource, the WAF attached should also be global which forces use to provision it on us-east-1 region.
- **No CloudWatch alarms** - while monitoring is enabled on ec2. No alarms were configured
- **Magnolia Installation Only** - Installation only 
