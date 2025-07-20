---
id: task-1
title: Improve SSO services
status: To Do
assignee: []
created_date: '2025-07-20'
labels: []
dependencies: []
---

## Description (the why)

Enhance the Single Sign-On (SSO) services to deliver a more reliable, secure, and seamless authentication experience for all users across the infrastructure. This initiative aims to address current pain points such as inconsistent login flows, fragmented user management, and potential security vulnerabilities. By improving SSO, the project will enable easier onboarding and offboarding, reduce the risk of credential sprawl, and ensure compliance with organizational security standards. The outcome will be a unified authentication layer that simplifies access for users and administrators while supporting future scalability and integration needs.

## Acceptance Criteria (the what)

- [ ] Standardize a single login flow across all infrastructure services using the chosen SSO provider.
- [ ] Integrate a centralized user directory (LDAP or OIDC) with each target service for unified identity management.
- [ ] Enforce multi-factor authentication (MFA) for all user logins to meet security policies.
- [ ] Implement automated user provisioning and deprovisioning workflows to streamline onboarding/offboarding.
- [ ] Achieve zero or minimal downtime during migration to the improved SSO framework.
- [ ] Configure monitoring and alerting for authentication errors and performance metrics.
- [ ] Allow user self-registration with manual administrator approval.
- [ ] Ensure SSO services remain lightweight and easy to maintain.
- [ ] Support modern authentication standards (e.g., FIDO2, mTLS) in the identity provider.

## Implementation Plan (the how)

1. Take stock of how SSO is set up today and note any quirks.
2. Pick a self-hosted SSO provider (kanidm or Authelia) and spin up quick POCs in the staging Nomad cluster to see which one 'just works' with basic LDAP/OIDC and MFA.
3. Tweak Nomad job specs to deploy the chosen provider securely (env vars, certs, storage).
4. Hook up each service via LDAP or OIDC, test logins, tokens, and sessions end to end.
5. Turn on MFA in the provider and update any client apps to require it.
6. Write simple scripts for user create/delete flows.
7. Smoke-test everything in staging, add basic integration tests for login and logout.
8. Do a gradual rollout (service by service), watch logs/metrics, and adjust if needed.
9. Update README/docs and jot down a quick runbook for future you/admins.
