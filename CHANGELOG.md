# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2025-08-17

### Fixed
- Fixed ECR login error by removing explicit registries parameter - the action now uses default ECR registry for the authenticated AWS account

## [1.1.0] - 2025-08-17

### Added
- Integration with KoalaOps/ensure-ecr-repository action for automatic ECR repository creation
- New `ensure_ecr_repository` input to enable repository creation before login
- Support for ECR region override with `ecr_region` input

## [1.0.0] - 2025-08-17

### Added
- Initial public release of AWS OIDC Action
- Support for AWS authentication using OpenID Connect (OIDC)
- Optional ECR login functionality
- Optional EKS cluster authentication and kubectl context setup
- Comprehensive input validation
- CloudFormation template for AWS infrastructure setup
- Complete documentation and usage examples
- Automated test workflow

### Features
- 🔐 Keyless authentication to AWS using OIDC
- 🐳 Docker login to Amazon ECR registries
- ☸️ Kubernetes context setup for EKS clusters
- ⚡ Flexible feature enablement (enable only what you need)
- 🛡️ Secure trust policies restricted to specific GitHub org/repo
- 📊 Comprehensive validation and error handling
- Initial stable release

---

## Release Notes Template

When creating a new release, use this template:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Now removed features

### Fixed
- Any bug fixes

### Security
- Security-related changes
```