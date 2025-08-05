# AWS OIDC Auth & Services Setup

A GitHub Action to authenticate to AWS using OpenID Connect (OIDC) / Workload Identity Federation, with optional ECR login and EKS cluster setup.

## Features

- 🔐 **Secure Authentication**: Uses OIDC for keyless authentication to AWS
- 🐳 **ECR Integration**: Optional Docker login to Amazon ECR
- ☸️ **EKS Support**: Optional kubectl context setup for EKS clusters
- ⚡ **Flexible**: Enable only the features you need
- 🛡️ **No Long-lived Keys**: Eliminates the need for AWS access keys in secrets

## Prerequisites

Before using this action, you need to set up the AWS OIDC infrastructure. See the [Setup Guide](#setup-guide) below.

## Usage

### Basic Usage (AWS Authentication Only)

```yaml
name: Deploy to AWS
on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write   # Required for OIDC
      contents: read    # Required for actions/checkout
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Configure AWS credentials
        uses: your-org/aws-oidc-action@v1
        with:
          aws_region: us-east-1
          role_to_assume: ${{ secrets.AWS_OIDC_ROLE }}
      
      - name: Run AWS CLI command
        run: aws s3 ls
```

### ECR Login Example

```yaml
name: Build and Push to ECR
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Configure AWS and ECR
        uses: your-org/aws-oidc-action@v1
        with:
          aws_region: us-east-1
          role_to_assume: ${{ secrets.AWS_OIDC_ROLE }}
          enable_ecr_login: true
          ecr_registry: 123456789012.dkr.ecr.us-east-1.amazonaws.com
      
      - name: Build and push Docker image
        run: |
          docker build -t my-app .
          docker tag my-app:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
          docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```

### EKS Deployment Example

```yaml
name: Deploy to EKS
on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Configure AWS and EKS
        uses: your-org/aws-oidc-action@v1
        with:
          aws_region: us-west-2
          role_to_assume: ${{ secrets.AWS_OIDC_ROLE }}
          enable_eks_auth: true
          eks_cluster_name: my-cluster
      
      - name: Deploy to Kubernetes
        run: |
          kubectl apply -f k8s/deployment.yaml
          kubectl rollout status deployment/my-app
```

### Complete Example (ECR + EKS)

```yaml
name: Build and Deploy
on: [push]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Configure AWS, ECR, and EKS
        uses: your-org/aws-oidc-action@v1
        with:
          aws_region: us-west-2
          role_to_assume: ${{ secrets.AWS_OIDC_ROLE }}
          enable_ecr_login: true
          ecr_registry: 123456789012.dkr.ecr.us-west-2.amazonaws.com
          enable_eks_auth: true
          eks_cluster_name: production-cluster
      
      - name: Build and push to ECR
        run: |
          docker build -t my-app .
          docker tag my-app:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/my-app:${{ github.sha }}
          docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/my-app:${{ github.sha }}
      
      - name: Update Kubernetes deployment
        run: |
          kubectl set image deployment/my-app container=123456789012.dkr.ecr.us-west-2.amazonaws.com/my-app:${{ github.sha }}
          kubectl rollout status deployment/my-app
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `aws_region` | AWS region for authentication | ✅ | - |
| `role_to_assume` | IAM role ARN to assume for authentication | ✅ | - |
| `enable_ecr_login` | Enable Docker login to ECR registry | ❌ | `false` |
| `ecr_registry` | ECR registry hostname (required if `enable_ecr_login` is true) | ❌ | - |
| `ecr_region` | ECR registry region (defaults to `aws_region` if not specified) | ❌ | - |
| `enable_eks_auth` | Enable EKS cluster authentication and kubectl context setup | ❌ | `false` |
| `eks_cluster_name` | EKS cluster name (required if `enable_eks_auth` is true) | ❌ | - |
| `eks_cluster_region` | EKS cluster region (defaults to `aws_region` if not specified) | ❌ | - |

## Setup Guide

### 1. Deploy AWS Infrastructure

First, you need to set up the AWS OIDC identity provider and IAM role. Use the provided CloudFormation template:

```bash
aws cloudformation create-stack \
  --stack-name github-actions-oidc \
  --template-body file://aws-oidc-cloudformation.yaml \
  --parameters ParameterKey=GitHubOrg,ParameterValue=your-github-org \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2. Get the Role ARN

After deployment, retrieve the role ARN:

```bash
aws cloudformation describe-stacks \
  --stack-name github-actions-oidc \
  --query 'Stacks[0].Outputs[?OutputKey==`GitHubActionsRoleArn`].OutputValue' \
  --output text
```

### 3. Configure GitHub Secret

Add the role ARN as a repository secret:

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `AWS_OIDC_ROLE`
5. Value: The role ARN from step 2

### 4. Update Workflow Permissions

Ensure your workflow has the required permissions:

```yaml
permissions:
  id-token: write   # Required for OIDC
  contents: read    # Required for actions/checkout (if used)
```

## Security Features

- **Keyless Authentication**: No long-lived AWS access keys needed
- **Least Privilege**: IAM role with minimal required permissions
- **Repository Scoped**: Trust policy restricts access to specific GitHub org/repo
- **Short-lived Tokens**: OIDC tokens are valid for the duration of the job only

## Troubleshooting

### Common Issues

1. **"No identity-based policy allows" errors**
   - Verify the IAM role has the required permissions
   - Check that ECR and EKS policies are attached if those features are enabled

2. **"AssumeRoleWithWebIdentity" failed**
   - Verify the GitHub org/repo names in the CloudFormation parameters
   - Ensure `id-token: write` permission is set in the workflow

3. **ECR registry parameter required**
   - When `enable_ecr_login: true`, you must provide `ecr_registry`

4. **EKS cluster name required**
   - When `enable_eks_auth: true`, you must provide `eks_cluster_name`

### Debug Mode

Enable debug logging by setting the `ACTIONS_STEP_DEBUG` secret to `true` in your repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Related Projects

- [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
- [aws-actions/amazon-ecr-login](https://github.com/aws-actions/amazon-ecr-login)