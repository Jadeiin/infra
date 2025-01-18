# Nomad Infrastructure Configurations

## Overview

This directory contains HashiCorp Nomad job specifications and configuration files for a self-hosted, privacy-focused infrastructure.

## Project Structure

```
nomad/
├── config/           # Nomad server and client configurations
│   ├── server.hcl    # Nomad server configuration
│   └── client.hcl    # Nomad client configuration
└── jobs/             # Nomad job specifications
    ├── csi/          # Container Storage Interface (CSI) plugins
    ├── dev/          # Development services
    ├── frontends/    # Privacy-focused frontend services
    ├── headscale/    # Tailscale control server
    ├── sso/          # Single Sign-On services
    ├── sync/         # Synchronization services
    └── traefik/      # Reverse proxy and load balancer
```

## Prerequisites

- HashiCorp Nomad
- Container runtime (Docker, Podman, or other OCI-compatible container engines)
- Overlay Networking Tool
  - Recommended: Nebula (available in Debian apt repository)
  - Alternatives: WireGuard, Tailscale, ZeroTier
- Appropriate network and storage infrastructure

## File Naming Convention

We use the `.nomad` file extension for Nomad job specifications instead of `.nomad.hcl`. This is a common pattern in many repositories and provides a more concise and convenient naming approach. While technically the files are HCL (HashiCorp Configuration Language), the `.nomad` extension has become a widely adopted convention in the Nomad community.

## Services Overview

The Nomad configuration includes various services across different categories:
- Frontend services
- Development tools
- Infrastructure components
- Storage solutions

Multiple Container Storage Interface (CSI) plugins are configured to provide flexible storage options.

## Getting Started

1. Configure your Nomad server and client using the files in `config/`
2. Apply job specifications using the Nomad CLI:
   ```bash
   nomad job run jobs/[category]/.../[service].nomad
   ```

## Contributing

- Ensure all job specifications follow Nomad best practices
- Test configurations in a staging environment before production deployment
- Update documentation when adding or modifying services

## Maintenance

Nomad job specifications are managed through automated dependency updates using Renovate.

### Best Practices
- Review auto-generated pull requests carefully
- Test updates in a staging environment
- Merge updates that pass automated checks
