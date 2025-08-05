# AWS OIDC Setup Guide

This guide walks you through setting up the AWS infrastructure required for the AWS OIDC Action.

## Prerequisites

- AWS CLI configured with administrator permissions
- A GitHub repository where you want to enable OIDC authentication

## Quick Setup

### 1. Deploy CloudFormation Stack

Choose one of the deployment options below:

#### Option A: Entire Organization Access
```bash
aws cloudformation create-stack \
  --stack-name github-actions-oidc \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters ParameterKey=GitHubOrg,ParameterValue=your-github-org \
  --capabilities CAPABILITY_NAMED_IAM
```

#### Option B: Specific Repository Only
```bash
aws cloudformation create-stack \
  --stack-name github-actions-oidc \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters \
    ParameterKey=GitHubOrg,ParameterValue=your-github-org \
    ParameterKey=GitHubRepo,ParameterValue=your-repo-name \
  --capabilities CAPABILITY_NAMED_IAM
```

#### Option C: Custom Role Name
```bash
aws cloudformation create-stack \
  --stack-name github-actions-oidc \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters \
    ParameterKey=GitHubOrg,ParameterValue=your-github-org \
    ParameterKey=RoleName,ParameterValue=my-custom-role \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2. Wait for Stack Creation

Monitor the stack creation:
```bash
aws cloudformation wait stack-create-complete --stack-name github-actions-oidc
```

### 3. Get the Role ARN

Retrieve the role ARN that was created:
```bash
aws cloudformation describe-stacks \
  --stack-name github-actions-oidc \
  --query 'Stacks[0].Outputs[?OutputKey==`GitHubActionsRoleArn`].OutputValue' \
  --output text
```

### 4. Configure GitHub Repository

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Name: `AWS_OIDC_ROLE`
5. Value: The role ARN from step 3

### 5. Update Your Workflows

Add the required permissions to your workflow:

```yaml
permissions:
  id-token: write   # Required for OIDC
  contents: read    # Required for actions/checkout
```

### 6. Clean Up Legacy Secrets (Optional)

If migrating from access keys, you can now safely remove:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Validation

Before deploying, you can validate the CloudFormation template:

```bash
chmod +x validate-cloudformation.sh
./validate-cloudformation.sh
```

## Advanced Configuration

### Multiple Environments

Create separate stacks for different environments:

```bash
# Development environment
aws cloudformation create-stack \
  --stack-name github-actions-oidc-dev \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters \
    ParameterKey=GitHubOrg,ParameterValue=myorg \
    ParameterKey=GitHubRepo,ParameterValue=dev-repo \
    ParameterKey=RoleName,ParameterValue=github-actions-dev-role

# Production environment
aws cloudformation create-stack \
  --stack-name github-actions-oidc-prod \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters \
    ParameterKey=GitHubOrg,ParameterValue=myorg \
    ParameterKey=GitHubRepo,ParameterValue=prod-repo \
    ParameterKey=RoleName,ParameterValue=github-actions-prod-role
```

### Updating the Stack

To modify permissions or parameters:

```bash
aws cloudformation update-stack \
  --stack-name github-actions-oidc \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters \
    ParameterKey=GitHubOrg,ParameterValue=your-github-org \
  --capabilities CAPABILITY_NAMED_IAM
```

## What Gets Created

The CloudFormation template creates:

1. **OIDC Identity Provider** - Establishes trust between AWS and GitHub Actions
2. **IAM Role** - A role that GitHub Actions can assume
3. **Policies** - Permissions for ECR and EKS operations

### Default Permissions

The IAM role includes:
- **ECR PowerUser** - Full access to Amazon ECR for container operations
- **EKS Read Access** - Ability to describe EKS clusters and resources
- **STS** - Identity verification capabilities
- **CloudFormation Read** - Access to describe stacks and resources

## Security Considerations

- The trust policy restricts access to your specified GitHub organization/repository
- OIDC tokens are short-lived (valid only for the duration of the workflow job)
- No long-lived credentials are stored in GitHub secrets
- The role follows the principle of least privilege

## Troubleshooting

### Common Issues

1. **Stack creation fails with "AlreadyExistsException"**
   - An OIDC provider may already exist. Check existing providers:
   ```bash
   aws iam list-open-id-connect-providers
   ```

2. **"InvalidParameterValue" for GitHub org/repo**
   - Ensure the organization and repository names are correct
   - Check that the names don't contain special characters

3. **Permission denied during workflow**
   - Verify the role ARN is correct in GitHub secrets
   - Check that the workflow has `id-token: write` permission
   - Ensure the role has the necessary AWS permissions

### Getting Help

If you encounter issues:
1. Check the CloudFormation stack events for error details
2. Verify your GitHub organization and repository names
3. Ensure AWS CLI has sufficient permissions to create IAM resources

## Cost Considerations

- **OIDC Identity Provider**: No additional cost
- **IAM Role**: No additional cost
- **STS API calls**: Minimal cost (typically < $1/month)

This setup eliminates the security risk and management overhead of long-lived access keys.