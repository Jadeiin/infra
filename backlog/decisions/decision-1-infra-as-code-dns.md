---
id: decision-1
title: Infrastructure as Code for DNS Management
date: '2025-07-20'
---

## Context
Currently, all services in our Nomad cluster use a wildcard domain for routing (e.g., `*.example.com`), and DNS records are managed manually outside of version control. This process is error-prone and does not scale as we onboard more services.

## Decision
We will adopt Infrastructure as Code (IaC) for DNS management to ensure reproducibility, auditability, and consistency of DNS records.

We evaluated two options:

1. **Terraform**
   - Leverages existing Terraform workflows and state management.
   - Broad provider support (Route53, Cloudflare, DigitalOcean, etc.).
   - Strong community and ecosystem.

2. **dnscontrol**
   - Language-agnostic DNS DSL with built-in support for multiple providers.
   - Simple versioning of DNS configs as code.

**Chosen option:** Terraform
- Aligns with our current infrastructure provisioning tooling.
- Allows us to manage DNS alongside other Nomad resources in a unified codebase.

## Consequences
- DNS records will be defined in `terraform/dns/` modules and versioned in Git.
- Wildcard records for the root domains will be updated to Terraform-managed resources.
- Access control for DNS is managed through Terraform state locking and IAM.
- dnscontrol remains on the shortlist if Terraform limitations arise or provider plugins are insufficient.
