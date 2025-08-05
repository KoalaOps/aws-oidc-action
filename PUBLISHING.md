# Publishing Guide

This guide walks through how to publish the AWS OIDC Action to the GitHub Marketplace.

## Prerequisites

1. **GitHub Repository**: Create a public GitHub repository for the action
2. **Repository Structure**: Ensure all files are in place (see checklist below)
3. **Testing**: Verify the action works in your environment

## Repository Setup

### 1. Create GitHub Repository

```bash
# Create a new public repository on GitHub, then:
cd /path/to/aws-oidc-action
git init
git add .
git commit -m "Initial release of AWS OIDC Action"
git branch -M main
git remote add origin https://github.com/your-org/aws-oidc-action.git
git push -u origin main
```

### 2. Repository Structure Checklist

Ensure these files are present:

- [ ] `action.yaml` - Main action definition
- [ ] `README.md` - Comprehensive documentation
- [ ] `LICENSE` - MIT license file
- [ ] `SETUP.md` - AWS infrastructure setup guide
- [ ] `CONTRIBUTING.md` - Contribution guidelines
- [ ] `CHANGELOG.md` - Version history
- [ ] `aws-oidc-cloudformation.yaml` - CloudFormation template
- [ ] `validate-cloudformation.sh` - Validation script
- [ ] `.github/workflows/test.yml` - Test workflow
- [ ] `examples/` - Usage examples directory

### 3. Verify Action Metadata

In `action.yaml`, ensure:
- Proper `name` and `description`
- All `inputs` are documented
- `branding` section (optional but recommended):

```yaml
branding:
  icon: 'shield'
  color: 'orange'
```

## Publishing Process

### 1. Create Initial Release

```bash
# Create and push tags
git tag -a v1.0.0 -m "Initial release"
git tag -a v1 -m "v1 major version tag"
git push origin v1.0.0
git push origin v1
```

### 2. GitHub Release

1. Go to your repository on GitHub
2. Click **Releases** → **Create a new release**
3. Choose tag `v1.0.0`
4. Title: `v1.0.0 - Initial Release`
5. Description:
   ```markdown
   ## 🚀 Initial Release
   
   ### Features
   - 🔐 Secure AWS authentication using OIDC
   - 🐳 Optional ECR login for Docker operations
   - ☸️ Optional EKS cluster setup
   - 📋 Comprehensive input validation
   - 🛡️ Security-focused with least privilege access
   
   ### What's Included
   - Complete action implementation
   - CloudFormation template for AWS setup
   - Comprehensive documentation
   - Usage examples
   - Automated tests
   
   See [README.md](README.md) for usage instructions and [SETUP.md](SETUP.md) for infrastructure setup.
   ```
6. Check **Set as the latest release**
7. Click **Publish release**

### 3. GitHub Marketplace

After creating the release:

1. GitHub will automatically detect it's an action
2. You'll see a prompt to publish to Marketplace
3. Click **Publish to Marketplace**
4. Fill out the marketplace form:
   - **Category**: Deployment
   - **Description**: Brief description matching `action.yaml`
   - **Tags**: aws, oidc, ecr, eks, docker, kubernetes
   - **Logo**: Upload a logo (optional)

### 4. Marketplace Verification

GitHub will review your action (usually takes a few hours to days). Ensure:
- Action follows [GitHub Actions guidelines](https://docs.github.com/en/actions/creating-actions/about-custom-actions)
- No security vulnerabilities
- Proper documentation
- Working test cases

## Versioning Strategy

### Major Version Tags

Always maintain major version tags for users:

```bash
# When releasing v1.1.0
git tag -a v1.1.0 -m "Release v1.1.0"
git tag -d v1
git tag -a v1 -m "v1 major version tag"
git push origin v1.1.0
git push origin v1 --force
```

### Release Schedule

- **Patch versions** (1.0.x): Bug fixes, documentation updates
- **Minor versions** (1.x.0): New features, backward compatible
- **Major versions** (x.0.0): Breaking changes

## Post-Publication

### 1. Update Documentation

Add the correct action reference to examples:
```yaml
uses: your-org/aws-oidc-action@v1
```

### 2. Monitor Usage

- Watch for issues and feedback
- Monitor action usage statistics
- Respond to user questions

### 3. Maintenance

- Keep dependencies updated (aws-actions/configure-aws-credentials, etc.)
- Update CloudFormation template as needed
- Add new features based on user feedback

## Troubleshooting

### Common Publishing Issues

1. **Action not detected**
   - Ensure `action.yaml` is in repository root
   - Check YAML syntax is valid

2. **Marketplace rejection**
   - Review GitHub's action guidelines
   - Ensure proper documentation
   - Check for security issues

3. **Version tag issues**
   - Don't delete published versions
   - Use semantic versioning
   - Update major version tags properly

### Getting Help

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Marketplace guidelines](https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace)
- [Community forums](https://github.community/)

## Example Marketing

Once published, consider:
- Blog post about the action
- Social media announcement
- Developer community sharing
- Integration with other tools/actions