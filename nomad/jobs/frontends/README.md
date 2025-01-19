# Alternative Frontends

## Overview

This directory contains a collection of alternative frontend services designed to enhance privacy, provide self-hosted alternatives, and offer more user-controlled access to various online platforms and services.

## Purpose

These frontends serve two primary goals:
1. **Privacy-Focused Alternatives**: Provide alternative interfaces to popular websites that prioritize user privacy and reduce tracking.
2. **Self-Hosted Services**: Enable users to host their own instances of various services, giving them more control over their data and access.

## Unique Characteristics of Frontend Services

### Stateless Nature
Unlike other self-hosted services in this infrastructure, frontend services are fundamentally different in their storage requirements:

- **No Persistent Storage Needed**: These services do not require dedicated volumes or persistent storage.
- **Stateless Design**: Each instance is ephemeral and can be easily recreated without data loss.
- **Minimal Resource Footprint**: Typically requires less memory and CPU.

### Why No Extra Storage?
- Act as lightweight proxies or alternative interfaces to existing web services
- Do not store user data or maintain long-term state
- Configuration is minimal and can be embedded directly in the job specification
- Can be redeployed instantly without data migration concerns

## Security Considerations

Most frontends are configured with security best practices:
- Running as non-root users
- Dropping unnecessary capabilities
- Using read-only root filesystems where possible
