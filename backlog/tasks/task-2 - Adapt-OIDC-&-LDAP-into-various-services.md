---
id: task-2
title: Adapt OIDC & LDAP into various services
status: To Do
assignee: []
created_date: '2025-07-20'
labels: []
dependencies:
  - task-1
---

## Description (the why)

Integrate OpenID Connect (OIDC) and LDAP authentication into multiple infrastructure services to provide unified, secure, and consistent user access. This adaptation will enable centralized identity management, improve user experience, and reduce administrative overhead by leveraging standardized authentication protocols.

Many services currently rely on disparate or legacy authentication mechanisms, leading to fragmented user identities and increased maintenance burden. By standardizing on OIDC and LDAP, the organization can ensure that access policies are enforced consistently, streamline user provisioning and deprovisioning, and facilitate compliance with security and audit requirements. This integration will also lay the groundwork for future enhancements such as multi-factor authentication and single sign-out, further strengthening the security and usability of the infrastructure.

## Acceptance Criteria (the what)

- [ ] Each service is configured to authenticate via the selected OIDC provider or LDAP directory.
- [ ] Authentication flows for all target services are verified in the staging environment.
- [ ] User provisioning and deprovisioning workflows operate via script without errors.
- [ ] Centralized logging and monitoring capture authentication events and metrics.
- [ ] Rollout to production has zero or minimal downtime.
- [ ] Configuration steps and credentials are documented in README or runbook.

## Implementation Plan (the how)

1. Inventory all services and note their current authentication methods.
2. Update Nomad job specs for each service to include OIDC or LDAP configuration (env vars, certificates, endpoints).
3. Deploy configuration changes to staging and test login, token validation, and session handling end to end.
4. Automate user provisioning and deprovisioning using simple scripts for create/delete.
5. Integrate authentication logs with centralized monitoring (e.g., Prometheus, ELK) and set up basic alerts.
6. Gradually roll out updates to production in batches, monitoring logs and metrics for errors.
7. Update documentation with step-by-step setup instructions and share with the team.
