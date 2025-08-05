#!/bin/bash

# Validate CloudFormation template
echo "Validating AWS OIDC CloudFormation template..."

if aws cloudformation validate-template --template-body file://aws-oidc-cloudformation.yaml > /dev/null 2>&1; then
    echo "✅ CloudFormation template is valid!"
    echo ""
    echo "Template Summary:"
    aws cloudformation validate-template --template-body file://aws-oidc-cloudformation.yaml --query 'Description' --output text
    echo ""
    echo "Parameters:"
    aws cloudformation validate-template --template-body file://aws-oidc-cloudformation.yaml --query 'Parameters[].{Name:ParameterKey,Description:Description,Default:DefaultValue}' --output table
else
    echo "❌ CloudFormation template validation failed!"
    aws cloudformation validate-template --template-body file://aws-oidc-cloudformation.yaml
    exit 1
fi