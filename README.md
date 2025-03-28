# Infrastructure as Code Repository

## Overview

This repository contains infrastructure configurations and deployment specifications for a self-hosted, privacy-focused, and automated infrastructure. The project leverages HashiCorp Nomad for container orchestration and includes a comprehensive set of services and tools.

## Project Structure

```
.
├── nomad/            # HashiCorp Nomad configurations
│   ├── config/       # Nomad server and client configurations
│   ├── jobs/         # Nomad job specifications for various services
│   └── README.md     # Detailed Nomad configurations and specifications
├── renovate.json     # Automated dependency management configuration
└── README.md         # Project documentation
```

## Key Components

### Infrastructure Management

#### Nomad Infrastructure
HashiCorp Nomad serves as the primary provisioning and orchestration tool. The `nomad/` directory contains configurations for:
- Frontend privacy-focused services
- Development tools
- Infrastructure services
- Storage solutions
- Networking components

For detailed information about the Nomad configurations, see the [Nomad README](nomad/README.md).

### Dependency Management

This project uses Renovate for automated dependency updates:
- Automatically checks for updates to container images
- Supports minor and patch version updates
- Configures automatic merging for non-major updates
- Specific rules for certain package sources (e.g., LinuxServer.io images)

## Dependency Update Strategies

The `renovate.json` configuration includes:
- Base configuration from Renovate
- Automatic updates for minor, patch, and pinned dependencies
- Special handling for Prometheus version updates
- Container image update detection in `.nomad` files

## Contributing

- Follow existing configuration patterns
- Test changes in a staging environment
- Update documentation when making modifications

## Maintenance

### Automatic Dependency Updates

Renovate will automatically create pull requests for dependency updates. Review and merge these updates to keep the infrastructure current and secure.

### Best Practices
- Review auto-generated pull requests carefully
- Test updates in a staging environment
- Merge updates that pass automated checks

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
