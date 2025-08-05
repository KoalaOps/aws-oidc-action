# Contributing to AWS OIDC Action

Thank you for your interest in contributing to the AWS OIDC Action! This document provides guidelines and information for contributors.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a feature request:

1. Check existing [Issues](../../issues) to avoid duplicates
2. Create a new issue with:
   - Clear, descriptive title
   - Detailed description of the problem or enhancement
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment details (OS, GitHub Actions runner, etc.)

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the guidelines below
4. **Test your changes** using the test workflow
5. **Commit with clear messages**:
   ```bash
   git commit -m "feat: add support for custom ECR regions"
   ```
6. **Push to your fork** and create a Pull Request

## Development Guidelines

### Code Standards

- Follow existing code style and patterns
- Keep the action focused and lightweight
- Ensure backward compatibility unless it's a breaking change
- Document any new inputs or outputs

### Testing

Before submitting a PR:

1. **Test locally** with different input combinations
2. **Validate CloudFormation template**:
   ```bash
   ./validate-cloudformation.sh
   ```
3. **Update tests** if adding new functionality
4. **Run the test workflow** in your fork

### Documentation

- Update `README.md` for any new features or changes
- Add examples for new functionality
- Update `SETUP.md` if infrastructure changes are needed
- Ensure inline comments explain complex logic

## Pull Request Guidelines

### PR Title Format

Use conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test-related changes
- `refactor:` for code refactoring

### PR Description

Include:
- **What**: Brief description of changes
- **Why**: Reason for the change
- **How**: Implementation approach
- **Testing**: How you tested the changes
- **Breaking Changes**: Any backward incompatible changes

### Review Process

1. Automated tests must pass
2. At least one maintainer review required
3. Address any feedback promptly
4. Squash commits when merging (if requested)

## Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Creating Releases

Maintainers will:
1. Create a new tag following semver
2. Update major version tag (e.g., `v1`)
3. Generate release notes
4. Update GitHub Marketplace listing

## Development Environment

### Prerequisites

- Git
- AWS CLI (for testing CloudFormation)
- GitHub CLI (optional, for easier PR management)

### Local Testing

1. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/aws-oidc-action.git
   cd aws-oidc-action
   ```

2. **Set up test environment**:
   - Configure AWS credentials for testing
   - Set up test GitHub repository secrets
   - Deploy test CloudFormation stack

3. **Test changes**:
   - Push to your fork
   - Run the test workflow
   - Verify all test cases pass

### CloudFormation Testing

Validate template changes:
```bash
# Validate syntax
./validate-cloudformation.sh

# Test deployment (use a test stack name)
aws cloudformation create-stack \
  --stack-name aws-oidc-action-test \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters ParameterKey=GitHubOrg,ParameterValue=your-test-org \
  --capabilities CAPABILITY_NAMED_IAM
```

## Questions or Help

- **Questions**: Open a [Discussion](../../discussions)
- **Issues**: Report via [Issues](../../issues)
- **Security**: Contact maintainers privately for security issues

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Maintain a professional environment

Thank you for contributing! 🚀